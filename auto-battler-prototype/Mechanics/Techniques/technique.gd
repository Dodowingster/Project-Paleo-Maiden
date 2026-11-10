@abstract
class_name Technique
extends Node
## Technique class used to create techniques that are used in loadouts

signal execution_status_changed(technique: Technique, status: bool)

## Technique class used to create techniques that are used in loadouts
enum TechniqueType { RUSH, REVERSAL, SHORT_RANGE, MID_RANGE, LONG_RANGE, PROJECTILE }

# Debug vars
## Reference to character name (mostly for debugging)
var character_name: String
## Reference to technique name (mostly for debugging)
var technique_name: String
var anim_name: String

# Var meat
## Array of triggers attached to the technique
var triggers: Array[Trigger]
## Array of effects attached to the technique
var effects: Array[Effect]
@onready var can_execute : bool = false
## Type of technique used for easier sorting/assignment of arrays
@onready var technique_type : TechniqueType
@onready var slot_priority : int = 0

func _ready() -> void:
	# Initialize triggers array
	var children = get_children()

	for child in children:
		# We only want the triggers
		if child is Trigger:
			triggers.append(child)
		if child is Effect:
			effects.append(child)

func setup_priority(slot_priority_val: int) -> void:
	slot_priority = slot_priority_val

## Initializes trigger and effect properties (if needed)
func setup_triggers_and_effects(character: Character) -> void:
	# Initialize character name (for debugging and potentially screen effects)
	self.character_name = character.character_name
	print(character_name)
	print(" Trigger setup for " + technique_name)

	for trigger in triggers:
		# if trigger is ActionGoalTrigger or trigger is HpTrigger or trigger is RangeTrigger \
		# or trigger is OppStateTrigger or trigger is PositionTrigger:
		trigger.character = character
		# print("character side: " + str(trigger.character.get_side()))
		print("  " + trigger.name + " trigger initialized")

	print(" Effect setup for " + technique_name)

	for effect in effects:
		#if effect is MoveEffect or effect is SideSwitchEffect:
		print("  " + effect.name + " effect initialized")
		effect.character = character

## Checks all triggers
func trigger_check() -> bool:
	var conditions_met : bool = true
	for trigger in triggers:
		if !trigger.check_condition():
			conditions_met = false
			break

	if conditions_met != can_execute:
		execution_status_changed.emit(self, conditions_met)
	can_execute = conditions_met
	return conditions_met

## The stuff that happens when trigger_check returns true
@abstract
func execute_technique() -> void
