extends Control

@export var dataTracker: DataTracker
@export var tickLabelValue: Label
@export var timerLabelValue: Label
@export var distanceLabelValue: Label

@export var P1: CharacterBody2D
@export var P1ActionGoalValueLabelValue: Label
@export var P1ActionGoalTotalLabelValue: Label
@export var P2: CharacterBody2D
@export var P2ActionGoalValueLabelValue: Label
@export var P2ActionGoalTotalLabelValue: Label

func _ready() -> void:
	tickLabelValue.text = str(0)
	timerLabelValue.text = "0.000s"
	distanceLabelValue.text = "0"
	P1ActionGoalTotalLabelValue.text = "/ " + str(P1.actionGoalTotal)
	P2ActionGoalTotalLabelValue.text = "/ " + str(P2.actionGoalTotal)

func _process(_delta: float) -> void:
	tickLabelValue.text = str(dataTracker.tickCount)
	timerLabelValue.text = str(snapped(dataTracker.timer, 0.001)) + "s"
	distanceLabelValue.text = str(snapped(dataTracker.distance, 0.001))
	
	P1ActionGoalValueLabelValue.text = str(P1.currentActionGoal)
	P2ActionGoalValueLabelValue.text = str(P2.currentActionGoal)
