extends Control

@export var dataTracker: DataTracker
@export var tickLabelValue: Label
@export var timerLabelValue: Label
@export var distanceLabelValue: Label

@onready var P1: Character
@export var P1ActionGoalValueLabelValue: Label
@export var P1ActionGoalTotalLabelValue: Label
@export var P1HealthValue : Label
@export var P1HealthTotal : Label
@export var P1TechniqueList : VBoxContainer

@onready var P2: Character
@export var P2ActionGoalValueLabelValue: Label
@export var P2ActionGoalTotalLabelValue: Label
@export var P2HealthValue : Label
@export var P2HealthTotal : Label
@export var P2TechniqueList : VBoxContainer

func _ready() -> void:
	tickLabelValue.text = str(0)
	timerLabelValue.text = "0.000s"
	distanceLabelValue.text = "0"


func char_setup() -> void:
	P1ActionGoalTotalLabelValue.text = "/ " + str(P1.actionGoalTotal)
	P1HealthTotal.text = "/ " + str(P1.maxHP)
	var techniqueList = P1.loadout.get_children()
	P1.loadout.updateTriggerStatus.connect(updateTechniqueStatusP1)
	for technique in techniqueList:
		if technique is Technique:
			var techniqueLabel : Label = Label.new()
			techniqueLabel.text = technique.name
			P1TechniqueList.add_child(techniqueLabel)
	
	P2ActionGoalTotalLabelValue.text = "/ " + str(P2.actionGoalTotal)
	P2HealthTotal.text = "/ " + str(P2.maxHP)
	techniqueList = P2.loadout.get_children()
	P2.loadout.updateTriggerStatus.connect(updateTechniqueStatusP2)
	for technique in techniqueList:
		if technique is Technique:
			var techniqueLabel : Label = Label.new()
			techniqueLabel.text = technique.name
			techniqueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			P2TechniqueList.add_child(techniqueLabel)

func _process(_delta: float) -> void:
	tickLabelValue.text = str(dataTracker.tickCount)
	timerLabelValue.text = str(snapped(dataTracker.timer, 0.001)) + "s"
	distanceLabelValue.text = str(snapped(dataTracker.distance, 0.001))
	
	P1ActionGoalValueLabelValue.text = str(P1.currentActionGoal)
	P1HealthValue.text = str(P1.health)
	P2ActionGoalValueLabelValue.text = str(P2.currentActionGoal)
	P2HealthValue.text = str(P2.health)

func updateTechniqueStatusP1(position: int, canExecute: bool) -> void:
	var techniqueLabel : Label = P1TechniqueList.get_child(position)
	if canExecute:
		techniqueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	else:
		techniqueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
func updateTechniqueStatusP2(position: int, canExecute: bool) -> void:
	var techniqueLabel : Label = P2TechniqueList.get_child(position)
	if canExecute:
		techniqueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		techniqueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
