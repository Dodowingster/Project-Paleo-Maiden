extends Node
class_name TickTracker

@export var tickInSeconds: float = 0.2
var tickCount: int = 0
var timeBeforeNextTick: float = 0

func _ready() -> void:
	tickCount = 0
	timeBeforeNextTick = tickInSeconds

func _process(delta: float) -> void:
	timeBeforeNextTick -= delta
	if timeBeforeNextTick <= 0:
		tickCount += 1
		timeBeforeNextTick = tickInSeconds - timeBeforeNextTick
