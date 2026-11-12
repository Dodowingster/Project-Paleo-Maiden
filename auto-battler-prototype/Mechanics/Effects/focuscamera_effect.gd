class_name FocusCameraEffect
extends Effect

@export var apply_frame : int
@export var revert_frame : int

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var camera_focus_changed : bool = false
@onready var prev_process_mode : ProcessMode
@onready var effect_done : bool = false

func execute_effect(delta: float) -> void:
	if not effect_done:
		if not camera_focus_changed:
			if time_elapsed > (apply_frame / 60.0):
				StageManager.change_camera_focus.emit([character])
				camera_focus_changed = true
		else:
			if time_elapsed > (revert_frame / 60.0):
				StageManager.restore_original_focus.emit()
				effect_done = true
		time_elapsed += delta

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	time_elapsed = 0
	camera_focus_changed = false
	effect_done = false
