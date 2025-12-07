extends Node
class_name TimeTracker

@export var ticksPerSecond: int = 60
var tickCount: int = 0
var timeBeforeNextTick: float = 0
var timer: float = 0

func _ready() -> void:
	tickCount = 0
	timeBeforeNextTick = 1/ticksPerSecond
	timer = 0

func _process(delta: float) -> void:
	timer += delta
	timeBeforeNextTick -= delta
	if timeBeforeNextTick <= 0:
		tickCount += 1
		timeBeforeNextTick = 1/ticksPerSecond - timeBeforeNextTick
