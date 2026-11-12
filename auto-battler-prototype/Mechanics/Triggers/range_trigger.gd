class_name RangeTrigger
extends Trigger

@export var min_range : float
@export var max_range : float
@onready var character : Character

func check_condition() -> bool:
	return character.distance >= min_range and character.distance <= max_range
