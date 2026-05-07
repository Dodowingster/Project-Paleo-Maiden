extends Node
class_name StateManager

@export var stateMachine : StateMachine
@export var character : Character
@export var sideTracker : SideTracker
@export var noActionGoalStates : Array[State]
@export var canBlockStates : Array[State]
var attackedOutcome = ""

func run_strategy_mods(strategy : GlobalValues.STRATEGY) -> void:
	pass
	#if strategy == GlobalValues.STRATEGY.AGGRESSIVE:
		#canBlockStates.clear()

func can_act() -> bool:
	return stateMachine.currentState is ActionableState or \
	(stateMachine.currentState is DashState and stateMachine.currentState.canAct)

func run_full_logic() -> void:
	# decide whether character can change sides
	sideTracker.set_side_lock(stateMachine.currentState is not ActionableState)
	if sideTracker.canFlip:
		character.face_opponent()
	
	# check if hit/blocked first
	attackedOutcome = ""
	if character.hit_by.size() > 0 and character.hurtboxes_hit.size() > 0:
		var index : int = 0
		while index < character.hit_by.size():
			#  and (character.currentActionGoal >= character.actionGoalTotal)
			if stateMachine.currentState in canBlockStates and (character.currentActionStock > 0):
				character.get_block_logic(character.hit_by[index], character.hurtboxes_hit[index])
				attackedOutcome = "Blockstun"
			else:
				character.get_hit_logic(character.hit_by[index], character.hurtboxes_hit[index])
				attackedOutcome = "Hitstun"
			index += 1
		var characterLoses : String = character.get_attacked_outcome()
		if characterLoses != "":
			attackedOutcome = characterLoses
		character.hit_by.clear()
		character.hurtboxes_hit.clear()
		if attackedOutcome != "":
			stateMachine.currentState.transition.emit(stateMachine.currentState, attackedOutcome)
	else:
		# action goal management
		if stateMachine.currentState not in noActionGoalStates:
			var rng_roll: int = randi() % (character.maxSta + 1) + character.minSta
			character.currentActionGoal += rng_roll
			if character.currentActionGoal >= character.actionGoalTotal and \
			character.currentActionStock < character.actionStocksTotal:
				character.currentActionGoal -= character.actionGoalTotal
				character.currentActionStock += 1
				print(character.characterName + " action stock + 1")
		
		# check if character has any executable techniques
		

	run_decision_logic(character.strategy)


func run_decision_logic(strategy : GlobalValues.STRATEGY) -> void:
	var chosenState : String = ""
	character.loadout.techniques_check()
	if can_act():
		if character.loadout.techniqueToExecute != null:
			chosenState = "Technique"
		else:
			if strategy == GlobalValues.STRATEGY.AGGRESSIVE:
				chosenState = aggressive_decision_logic()
			elif strategy == GlobalValues.STRATEGY.BALANCED:
				chosenState = balanced_decision_logic()
			elif strategy == GlobalValues.STRATEGY.EVASIVE:
				chosenState = evasive_decision_logic()
	
	if chosenState != "" and stateMachine.currentState.name != chosenState:
		stateMachine.currentState.transition.emit(stateMachine.currentState, chosenState)

func aggressive_decision_logic() -> String:
	var chosenState : String = ""
	if character.check_can_attack():
		chosenState = "BaseAttack"
	else:
		if character.min_distance_hit():
			if character.check_can_clash():
				chosenState = "Clashing"
			else:
				chosenState = "Idle"
		elif character.in_attack_range():
			chosenState = "MoveForward"
		else:
			chosenState = "DashForward"
	
	return chosenState

func balanced_decision_logic() -> String:
	var chosenState : String = ""
	
	if character.stateMachine.currentState.name == "Idle":
		chosenState = "MoveForward"
		
	if character.check_want_to_attack():
		if character.distance > character.maxDistance:
			chosenState = "MoveForward"
		elif character.min_distance_hit():
			if character.check_can_clash():
				chosenState = "Clashing"
			else:
				chosenState = "MoveBackward"
		else:
			chosenState = "BaseAttack"
	else:
		if character.opponentIsAttacking:
			chosenState = "DashBackward"
		else:
			if character.min_distance_hit():
				if character.check_can_clash():
					chosenState = "Clashing"
				else:
					chosenState = "MoveBackward"
			elif character.distance > character.maxDistance:
				chosenState = "DashForward"
	
	return chosenState
	
func evasive_decision_logic() -> String:
	var chosenState : String = ""
	
	if character.check_want_to_attack():
		if character.opponentIsAttacking:
			chosenState = "DashBackward"
		else:
			if character.check_can_attack():
				chosenState = "BaseAttack"
			else:
				chosenState = "DashForward"
	else:
		if character.min_distance_hit():
			if character.check_can_clash():
				chosenState = "Clashing"
			else:
				chosenState = "DashBackward"
		else:
			if character.opponentIsAttacking:
				chosenState = "DashBackward"
			else:
				chosenState = "MoveForward"
	
	return chosenState
