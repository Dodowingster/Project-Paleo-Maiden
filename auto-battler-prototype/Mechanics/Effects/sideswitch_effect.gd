class_name SideSwitchEffect
extends Effect

@export var apply_frame : int
@export var revert_frame : int

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var col_disabled : bool = false
@onready var effect_done : bool = false

func execute_effect(delta: float) -> void:
	if not effect_done:
		if not col_disabled:
			if time_elapsed > (apply_frame / 60.0):
				character.toggle_collision(false)
				col_disabled = true
		else:
			if time_elapsed > (revert_frame / 60.0):
				character.toggle_collision(true)
				col_disabled = false
				effect_done = true
		time_elapsed += delta

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	character.toggle_collision(true)
	time_elapsed = 0
	col_disabled = false
	effect_done = false
