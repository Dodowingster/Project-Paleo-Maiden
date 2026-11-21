class_name HpTrigger
extends Trigger
## Trigger class for checking against a set HP value

## The upper HP value to check against (inclusive).
@export var hp_criteria_upper : float = 100

## The lower HP value to check against (inclusive).
@export var hp_criteria_lower : float = 1

## Reference to the character node.
@onready var character : Character

## Checks the HP Check Mode set in the inspector.
func check_condition() -> bool:
	return ((character.stat_manager.hp_component.current_hp * 1.0/character.stat_manager.hp_component.max_hp) * 100.0) <= hp_criteria_upper && \
	((character.stat_manager.hp_component.current_hp * 1.0/character.stat_manager.hp_component.max_hp * 100.0)) >= hp_criteria_lower
