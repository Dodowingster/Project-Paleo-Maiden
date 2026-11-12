class_name OppStateTrigger
extends Trigger

@onready var character : Character

func check_condition() -> bool:
	return character.opponent_is_attacking