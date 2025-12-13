extends Node
class_name DataTracker

@export var ticksPerSecond: int = 60
var tickCount: int = 0
var tickAccumulator: float = 0.000
var timer: float = 0.000

@export var char1: CharacterBody2D
@export var char2: CharacterBody2D
var distance: float = 0.000


func _ready() -> void:
	tickCount = 0
	tickAccumulator = 0.000
	timer = 0.000

func _process(delta: float) -> void:
	timer += delta
	tickAccumulator += delta
	while tickAccumulator >= 1.0/ticksPerSecond:
		tickCount += 1
		distance = get_distance_between_chars()
		tickAccumulator -= 1.0/ticksPerSecond
		GlobalValues.updateDataToChar.emit(distance, tickCount)

func get_distance_between_chars():
	return abs(char2.position.x - char1.position.x)
		
