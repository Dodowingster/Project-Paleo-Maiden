extends Control

@export var dataTracker: DataTracker
@export var tickLabelValue: Label
@export var timerLabelValue: Label
@export var distanceLabelValue: Label

@export var P1: CharacterBody2D
@export var P1ActionGoalValueLabelValue: Label
@export var P1ActionGoalTotalLabelValue: Label
@export var P1HealthValue : Label
@export var P1HealthTotal : Label

@export var P2: CharacterBody2D
@export var P2ActionGoalValueLabelValue: Label
@export var P2ActionGoalTotalLabelValue: Label
@export var P2HealthValue : Label
@export var P2HealthTotal : Label

func _ready() -> void:
	tickLabelValue.text = str(0)
	timerLabelValue.text = "0.000s"
	distanceLabelValue.text = "0"
	P1ActionGoalTotalLabelValue.text = "/ " + str(P1.actionGoalTotal)
	P1HealthTotal.text = "/ " + str(P1.maxHP)
	P2ActionGoalTotalLabelValue.text = "/ " + str(P2.actionGoalTotal)
	P2HealthTotal.text = "/ " + str(P2.maxHP)

func _process(_delta: float) -> void:
	tickLabelValue.text = str(dataTracker.tickCount)
	timerLabelValue.text = str(snapped(dataTracker.timer, 0.001)) + "s"
	distanceLabelValue.text = str(snapped(dataTracker.distance, 0.001))
	
	P1ActionGoalValueLabelValue.text = str(P1.currentActionGoal)
	P1HealthValue.text = str(P1.health)
	P2ActionGoalValueLabelValue.text = str(P2.currentActionGoal)
	P2HealthValue.text = str(P2.health)
