class_name ActionableTrigger
extends Trigger

@onready var character : Character

func check_condition() -> bool:
	return character.state_machine.current_state is ActionableState
