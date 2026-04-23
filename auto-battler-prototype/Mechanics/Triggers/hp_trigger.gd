extends Trigger
class_name HpTrigger
## Trigger class for checking against a set HP value 

## The upper HP value to check against (inclusive).
@export var hpCriteriaUpper : float = 100

## The lower HP value to check against (inclusive).
@export var hpCriteriaLower : float = 1

## Reference to the character node.
@onready var character : Character

## Checks the HP Check Mode set in the inspector.
func check_condition() -> bool:
	return ((character.health * 1.0/character.maxHP) * 100.0) <= hpCriteriaUpper && \
	((character.health * 1.0/character.maxHP * 100.0)) >= hpCriteriaLower
