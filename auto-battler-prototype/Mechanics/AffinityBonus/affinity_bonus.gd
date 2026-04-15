extends Node
class_name AffinityBonus

## Array of triggers attached to the technique
var triggers: Array[Trigger]
## Array of effects attached to the technique
var effects: Array[Effect]
var canExecute : bool = false
@export var affEffectName : String

func _ready() -> void:
	var children = get_children()
	
	for child in children:
		# We only want the triggers
		if child is Trigger:
			triggers.append(child)
		if child is Effect:
			effects.append(child)

## Initializes trigger and effect properties (if needed)
func setup_triggers_and_effects(character: Character) -> void:
	for trigger in triggers:
		trigger.character = character
	
	for effect in effects:
		effect.character = character

func trigger_check() -> bool:
	var conditions_met : bool = true
	for trigger in triggers:
		if !trigger.check_condition():
			conditions_met = false
			break

	canExecute = conditions_met
	return conditions_met

func execute_effects(delta : float) -> void:
	for effect in effects:
		effect.execute_effect(delta)
		effect.reset()
		for trigger in triggers:
			if trigger is CooldownTrigger:
				trigger.reset()
