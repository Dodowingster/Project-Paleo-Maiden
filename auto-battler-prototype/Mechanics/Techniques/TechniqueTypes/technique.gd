@abstract
extends Node
class_name Technique

enum TECHNIQUE_TYPE { RUSH, REVERSAL, SHORT_RANGE, MID_RANGE, LONG_RANGE, PROJECTILE }

var triggers : Array[Trigger]
@export var effects: Array
@onready var techniqueName : String
@onready var techniqueType : TECHNIQUE_TYPE
#@onready var hitboxList: Array[HitBox] 
#@onready var hurtboxList: Array[Hurtbox]
#
#
#@export var startup: Array[int]
#@export var active: Array[int]
#@export var recovery: Array[int]
#
#@export var hurtboxShowAt: Array[int]
#@export var hurtboxActive: Array[int]

func _ready() -> void:
	# Initialize triggers array
	var children = get_children()

	for child in children:
		# We only want the triggers
		if child is Trigger:
			triggers.append(child)

func setup_triggers(character: Character) -> void:
	for trigger in triggers:
		if trigger is ActionGoalTrigger:
			print("Action goal trigger triggered")
			trigger.character = character
		if trigger is HpTrigger:
			print("HP trigger triggered")
			trigger.character = character

func _process(_delta: float) -> void:
	var conditions_met : bool = true
	for trigger in triggers:
		if !trigger.check_condition():
			conditions_met = false
			break
	if conditions_met:
		print("Execute skill.")
