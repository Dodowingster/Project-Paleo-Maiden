extends Node
class_name StateManager

@export var stateMachine : StateMachine
@export var character : Character
@export var sideTracker : SideTracker
@export var noActionGoalStates : Array[State]

func run_full_logic() -> void:
	sideTracker.set_side_lock(stateMachine.currentState is not ActionableState)
	if sideTracker.canFlip:
		character.face_opponent()
	
	# action goal management
	if stateMachine.currentState not in noActionGoalStates:
		var rng_roll: int = randi() % (character.maxSta + 1) + character.minSta
		character.currentActionGoal += rng_roll
	
	character.loadout.techniques_check()
	if character.loadout.techniqueToExecute != null:
		character.opponent.opponentIsAttacking = true
	else:
		if character.strategy == GlobalValues.STRATEGY.BALANCED:
			if character.check_want_to_attack() and character.distance > character.minDistance and \
			character.distance < character.maxDistance:
				character.opponent.opponentIsAttacking = true
		else:
			if character.check_can_attack():
				character.opponent.opponentIsAttacking = true
	
	if character.opponent.stateMachine.currentState is ActionableState:
		var oppStateManager : StateManager = character.opponent.get_node("StateManager")
		oppStateManager.run_decision_logic(character.opponent.strategy)


func run_decision_logic(strategy : GlobalValues.STRATEGY) -> void:
	var chosenState : String = ""
	if character.loadout.techniqueToExecute != null:
		chosenState = "Technique"
	else:
		if strategy == GlobalValues.STRATEGY.AGGRESSIVE:
			chosenState = aggressive_decision_logic()
		elif strategy == GlobalValues.STRATEGY.BALANCED:
			chosenState = balanced_decision_logic()
	
	if chosenState != "" and stateMachine.currentState.name != chosenState:
		stateMachine.currentState.transition.emit(stateMachine.currentState, chosenState)

func aggressive_decision_logic() -> String:
	var chosenState : String = ""
	if character.check_can_attack():
		chosenState = "BaseAttack"
	else:
		if character.opponentIsAttacking:
			if character.check_want_to_attack():
				chosenState = "MoveForward"
			else:
				chosenState = "MoveBackward"
		else:
			if character.min_distance_hit():
				if character.opponent.min_distance_hit() and character.canClash and character.opponent.canClash:
					chosenState = "Clashing"
				else:
					chosenState = "Idle"
			else:
				chosenState = "MoveForward"
	
	return chosenState

func balanced_decision_logic() -> String:
	var chosenState : String = ""
	
	if character.stateMachine.currentState.name == "Idle":
		chosenState = "MoveBackward"
		
	if character.check_want_to_attack():
		if character.distance > character.maxDistance:
			chosenState = "MoveForward"
		elif character.min_distance_hit():
			if character.opponent.min_distance_hit() and character.canClash and character.opponent.canClash:
				chosenState = "Clashing"
			else:
				chosenState = "MoveBackward"
		else:
			chosenState = "BaseAttack"
	else:
		if character.opponentIsAttacking:
			chosenState = "MoveBackward"
		else:
			if character.min_distance_hit():
				if character.opponent.min_distance_hit() and character.canClash and character.opponent.canClash:
					chosenState = "Clashing"
				else:
					chosenState = "MoveBackward"
			elif character.distance > character.maxDistance:
				chosenState = "MoveForward"
	
	return chosenState
	
