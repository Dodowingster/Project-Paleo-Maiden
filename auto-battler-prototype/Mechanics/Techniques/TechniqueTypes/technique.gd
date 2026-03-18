@abstract
extends Node
class_name Technique

signal executionStatusChanged(technique: Technique, status: bool)

enum TECHNIQUE_TYPE { RUSH, REVERSAL, SHORT_RANGE, MID_RANGE, LONG_RANGE, PROJECTILE }

# debug vars
var characterName: String
var techniqueName: String
var animName: String

var triggers: Array[Trigger]
var effects: Array[Effect]
@onready var canExecute : bool = false
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

func setup_triggers_and_effects(character: Character) -> void:
	# Initialize character name (for debugging and potentially screen effects)
	self.characterName = character.characterName
	print(characterName)
	print(" Trigger setup for " + techniqueName)

	for trigger in triggers:
		#if trigger is ActionGoalTrigger:
			#print("	Action goal trigger initialized")
			#trigger.character = character
		#if trigger is HpTrigger:
			#print("	HP trigger initialized")
			#trigger.character = character
		#if trigger is RangeTrigger:
			#print(" Range trigger initialized")
			#trigger.character = character
		if trigger is ActionGoalTrigger or trigger is HpTrigger or trigger is RangeTrigger \
		or trigger is OppStateTrigger:
			trigger.character = character
		print("  " + trigger.name + " trigger initialized")
	
	print(" Effect setup for " + techniqueName)
	
	for effect in effects:
		if effect is MoveEffect:
			print("  " + effect.name + " effect initialized")
			effect.character = character

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

@abstract
func execute_technique() -> void
