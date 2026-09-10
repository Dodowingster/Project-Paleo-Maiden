extends Node

@export var min_scout_val = 1
@export var max_scout_val = 6
@export var player : MapPlayer
@export var scout_value_ui : Label


func _ready() -> void:
	player.broadcastScoutValue.connect(update_scout_ui)


func scout_roll() -> int:
	return randi_range(min_scout_val, max_scout_val)


func _on_scout_button_pressed() -> void:
	player.scout_initialize_move(scout_roll())


func update_scout_ui(value: int) -> void:
	scout_value_ui.text = str(value)


func _on_end_move_button_pressed() -> void:
	player.end_move()
