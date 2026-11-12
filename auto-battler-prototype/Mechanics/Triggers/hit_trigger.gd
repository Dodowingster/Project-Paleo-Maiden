class_name HitTrigger
extends Trigger

@onready var character : Character

func check_condition() -> bool:
	return character.state_machine.current_state is StateHitstun
