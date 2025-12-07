extends Control

@export var tickTracker: TimeTracker
@export var tickLabelValue: Label
@export var timerLabelValue: Label

func _ready() -> void:
	tickLabelValue.text = str(0)
	timerLabelValue.text = "0.000s"

func _process(_delta: float) -> void:
	tickLabelValue.text = str(tickTracker.tickCount)
	timerLabelValue.text = str(snapped(tickTracker.timer, 0.001)) + "s"
