class_name DataTracker
extends Node

@export var ticks_per_second: int = 60
var tick_count: int = 0
var tick_accumulator: float = 0.000
var timer: float = 0.000
var distance: float = 0.000

@onready var char1: CharacterBody2D
@onready var char2: CharacterBody2D



func _ready() -> void:
	reset()

func reset() -> void:
	tick_count = 0
	tick_accumulator = 0.000
	timer = 0.000

func _process(delta: float) -> void:
	timer += delta
	tick_accumulator += delta
	while tick_accumulator >= 1.0/ticks_per_second:
		tick_count += 1
		distance = get_distance_between_chars()
		tick_accumulator -= 1.0/ticks_per_second
		GlobalValues.update_data_to_char.emit(distance, tick_count)

func get_distance_between_chars():
	return abs(char2.position.x - char1.position.x)
