@abstract
extends Node
class_name Technique
## Technique class used to create techniques that are used in loadouts

signal executionStatusChanged(technique: Technique, status: bool)

enum TECHNIQUE_TYPE { RUSH, REVERSAL, SHORT_RANGE, MID_RANGE, LONG_RANGE, PROJECTILE }

# Debug vars
## Reference to character name (mostly for debugging)
var characterName: String
## Reference to technique name (mostly for debugging)
var techniqueName: String
var animName: String

# Var meat
## Array of triggers attached to the technique
var triggers: Array[Trigger]
## Array of effects attached to the technique
var effects: Array[Effect]
@onready var canExecute : bool = false
## Type of technique used for easier sorting/assignment of arrays
@onready var techniqueType : TECHNIQUE_TYPE
@onready var slotPriority : int = 0

func _ready() -> void:
	# Initialize triggers array
	var children = get_children()

	for child in children:
		# We only want the triggers
		if child is Trigger:
			triggers.append(child)
		if child is Effect:
			effects.append(child)

func setup_priority(slotPriorityVal: int) -> void:
	slotPriority = slotPriorityVal

## Initializes trigger and effect properties (if needed)
func setup_triggers_and_effects(character: Character) -> void:
	# Initialize character name (for debugging and potentially screen effects)
	self.characterName = character.characterName
	print(characterName)
	print(" Trigger setup for " + techniqueName)

	for trigger in triggers:
		#if trigger is ActionGoalTrigger or trigger is HpTrigger or trigger is RangeTrigger \
		#or trigger is OppStateTrigger:
		trigger.character = character
		print("  " + trigger.name + " trigger initialized")
	
	print(" Effect setup for " + techniqueName)
	
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

	if conditions_met != canExecute:
		executionStatusChanged.emit(self, conditions_met)
	canExecute = conditions_met
	return conditions_met

## The stuff that happens when trigger_check returns true
@abstract
func execute_technique() -> void
