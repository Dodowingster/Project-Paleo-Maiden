class_name StateManager
extends Node

@export var state_machine : CharStateMachine
@export var character : Character
@export var side_tracker : SideTracker
@export var no_action_goal_states : Array[State]
@export var can_block_states : Array[State]
var attacked_outcome = ""
@onready var strategy_run : bool = false
@onready var state_chosen : String = ""

func can_act() -> bool:
	return state_machine.current_state is ActionableState or \
	(state_machine.current_state is DashState and state_machine.current_state.can_act)

func run_full_logic() -> void:
	# decide whether character can change sides
	side_tracker.set_side_lock(state_machine.current_state is not ActionableState)
	if side_tracker.can_flip:
		character.face_opponent()

	# check if hit/blocked first
	attacked_outcome = ""
	if character.hit_by.size() > 0 and character.hurtboxes_hit.size() > 0:
		var index : int = 0
		while index < character.hit_by.size():
			#  and (character.current_action_goal >= character.action_goal_total)
			if state_machine.current_state in can_block_states and (character.current_action_stock > 0):
				character.get_block_logic(character.hit_by[index], character.hurtboxes_hit[index])
				attacked_outcome = "Blockstun"
			else:
				character.get_hit_logic(character.hit_by[index], character.hurtboxes_hit[index])
				attacked_outcome = "Hitstun"
			index += 1
		var character_loses : String = character.get_attacked_outcome()
		if character_loses != "":
			attacked_outcome = character_loses
		character.hit_by.clear()
		character.hurtboxes_hit.clear()
		if attacked_outcome != "":
			state_machine.current_state.transition.emit(state_machine.current_state, attacked_outcome)
	else:
		# action goal management
		if state_machine.current_state not in no_action_goal_states:
			var rng_roll: int = randi() % (character.max_sta + 1) + character.min_sta
			character.current_action_goal += rng_roll
			if character.current_action_goal >= character.action_goal_total and \
			character.current_action_stock < character.action_stocks_total:
				character.current_action_goal -= character.action_goal_total
				character.current_action_stock += 1
				print(character.character_name + " action stock + 1")

	state_chosen = run_decision_logic(character.strategy)
	if strategy_run and character.opponent.state_manager.strategy_run:
		if state_chosen != "" and state_machine.current_state.name != state_chosen:
			state_machine.current_state.transition.emit(state_machine.current_state, state_chosen)
		var opponent : Character = character.opponent
		if opponent.state_manager.state_chosen != "" and \
		opponent.state_machine.current_state.name != opponent.state_manager.state_chosen:
			opponent.state_machine.current_state.transition.emit\
			(opponent.state_machine.current_state, opponent.state_manager.state_chosen)
		strategy_run = false
		character.opponent.state_manager.strategy_run = false

func run_decision_logic(strategy : GlobalValues.Strategy) -> String:
	var chosen_state : String = ""
	character.loadout.techniques_check()
	if can_act():
		if character.loadout.technique_to_execute != null:
			chosen_state = "Technique"
		else:
			if strategy == GlobalValues.Strategy.AGGRESSIVE:
				chosen_state = aggressive_decision_logic()
			elif strategy == GlobalValues.Strategy.BALANCED:
				chosen_state = balanced_decision_logic()
			elif strategy == GlobalValues.Strategy.EVASIVE:
				chosen_state = evasive_decision_logic()
	strategy_run = true
	return chosen_state
	#if chosen_state != "" and state_machine.current_state.name != chosen_state:
		#state_machine.current_state.transition.emit(state_machine.current_state, chosen_state)

func aggressive_decision_logic() -> String:
	var chosen_state : String = ""
	if character.check_can_attack():
		chosen_state = "BaseAttack"
	else:
		if character.min_distance_hit():
			if character.check_can_clash():
				chosen_state = "Clashing"
			else:
				chosen_state = "Idle"
		elif character.in_attack_range():
			chosen_state = "MoveForward"
		else:
			chosen_state = "DashForward"

	return chosen_state

func balanced_decision_logic() -> String:
	var chosen_state : String = ""

	if character.state_machine.current_state.name == "Idle":
		chosen_state = "MoveForward"

	if character.check_want_to_attack():
		if character.distance > character.max_distance:
			chosen_state = "MoveForward"
		elif character.min_distance_hit():
			if character.check_can_clash():
				chosen_state = "Clashing"
			else:
				chosen_state = "MoveBackward"
		else:
			chosen_state = "BaseAttack"
	else:
		if character.opponent_is_attacking:
			chosen_state = "MoveBackward"
		else:
			if character.min_distance_hit():
				if character.check_can_clash():
					chosen_state = "Clashing"
				else:
					chosen_state = "DashBackward"
			elif character.distance > (character.max_distance * 1.3):
				chosen_state = "DashForward"

	return chosen_state

func evasive_decision_logic() -> String:
	var chosen_state : String = ""

	if character.check_want_to_attack():
		if character.opponent_is_attacking:
			chosen_state = "DashBackward"
		else:
			if character.check_can_attack():
				chosen_state = "BaseAttack"
			else:
				chosen_state = "DashForward"
	else:
		if character.min_distance_hit():
			if character.check_can_clash():
				chosen_state = "Clashing"
			else:
				chosen_state = "DashBackward"
		else:
			if character.opponent_is_attacking:
				chosen_state = "DashBackward"
			else:
				chosen_state = "MoveForward"

	return chosen_state
