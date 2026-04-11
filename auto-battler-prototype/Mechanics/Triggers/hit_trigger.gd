extends Trigger
class_name HitTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.stateMachine.currentState is StateHitstun
