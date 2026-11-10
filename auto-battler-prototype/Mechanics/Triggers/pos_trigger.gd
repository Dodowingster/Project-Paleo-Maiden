class_name PositionTrigger
extends Trigger
## Trigger class for checking against a set position range

## The direction to check the position
enum CheckDir {TO_CENTER, TO_CORNER}
@export var check_direction: CheckDir

## The coordinate to check against (inclusive). Must be less than pos2.
@export var pos_check: float = 150.0

## The center of the stage
@export var center_pos: float = 400.0

## Reference to the character node.
@onready var character : Character

func check_condition() -> bool:
	var side = character.get_side()
	var char_pos = character.global_position.x

	if check_direction == CheckDir.TO_CENTER:
		if side > 0:
			return char_pos >= center_pos - pos_check
		return char_pos <= center_pos + pos_check

	# elif check_direction == CheckDir.TO_CORNER:
	if side > 0:
		return char_pos <= center_pos - pos_check
	# else:
	return char_pos >= center_pos + pos_check

	return false
