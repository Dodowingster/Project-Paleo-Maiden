extends Trigger
class_name ClashingTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.stateMachine.currentState is StateClashing
