extends Trigger
class_name PositionTrigger
## Trigger class for checking against a set position range

## The direction to check the position
enum CheckDir {TO_CENTER, TO_CORNER}
@export var checkDirection: CheckDir

## The coordinate to check against (inclusive). Must be less than pos2.
@export var posCheck: float = 150.0

## The center of the stage
@export var centerPos: float = 400.0

## Reference to the character node.
@onready var character : Character

func check_condition() -> bool:
	var side = character.get_side()
	var charPos = character.global_position.x

	if checkDirection == CheckDir.TO_CENTER:
		if side > 0:
			return charPos >= centerPos - posCheck
		else:
			return charPos <= centerPos + posCheck

	elif checkDirection == CheckDir.TO_CORNER:
		if side > 0:
			return charPos <= centerPos - posCheck
		else:
			return charPos >= centerPos + posCheck

	return false
