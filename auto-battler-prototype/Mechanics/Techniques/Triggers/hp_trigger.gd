extends Trigger
class_name HpTrigger
## Trigger class for checking against a set HP value 

## The upper HP value to check against (inclusive).
@export var hpCriteriaUpper : int = 100

## The lower HP value to check against (inclusive).
@export var hpCriteriaLower : int = 1

## Reference to the character node.
@onready var character : Character

## Checks the HP Check Mode set in the inspector.
func check_condition() -> bool:
	return character.health <= hpCriteriaUpper && character.health >= hpCriteriaLower
