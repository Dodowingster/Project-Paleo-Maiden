extends Control

@export var dataTracker: DataTracker
@export var tickLabelValue: Label
@export var timerLabelValue: Label
@export var distanceLabelValue: Label

func _ready() -> void:
	tickLabelValue.text = str(0)
	timerLabelValue.text = "0.000s"
	distanceLabelValue.text = "0"

func _process(_delta: float) -> void:
	tickLabelValue.text = str(dataTracker.tickCount)
	timerLabelValue.text = str(snapped(dataTracker.timer, 0.001)) + "s"
	distanceLabelValue.text = str(snapped(dataTracker.distance, 0.001))
