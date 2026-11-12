class_name AffinityBonus
extends Node

@export var aff_effect_name : String
@export var trigger_limit : int = -1 # negative means no limit

## Array of triggers attached to the technique
var triggers: Array[Trigger]
## Array of effects attached to the technique
var effects: Array[Effect]
var can_execute : bool = false

@onready var trigger_count : int = 0

func _ready() -> void:
	var children = get_children()
	trigger_count = max(trigger_limit, 0)
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
	if trigger_limit == -1 or trigger_count > 0:
		var conditions_met : bool = true
		for trigger in triggers:
			if !trigger.check_condition():
				conditions_met = false
				break

		can_execute = conditions_met
		return conditions_met
	return false

func execute_effects(delta : float) -> void:
	for effect in effects:
		effect.execute_effect(delta)
		effect.reset()
		for trigger in triggers:
			if trigger is CooldownTrigger:
				trigger.reset()
	trigger_count -= 1
