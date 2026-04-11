extends Trigger
class_name ActionableTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.stateMachine.currentState is ActionableState
