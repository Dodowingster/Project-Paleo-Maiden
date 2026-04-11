extends Trigger
class_name RangeTrigger

@onready var character : Character
@export var minRange : float
@export var maxRange : float

func check_condition() -> bool:
	return character.distance >= minRange and character.distance <= maxRange
