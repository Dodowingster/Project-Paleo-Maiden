class_name ZoomCameraEffect
extends Effect

@export var apply_frame : int
@export var revert_frame : int
@export var zoom : Vector2 = Vector2(1, 1)

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var camera_zoom_changed : bool = false
@onready var effect_done : bool = false

func execute_effect(delta: float) -> void:
	if not effect_done:
		if not camera_zoom_changed:
			if time_elapsed > (apply_frame / 60.0):
				StageManager.change_camera_zoom.emit(zoom)
				camera_zoom_changed = true
		else:
			if time_elapsed > (revert_frame / 60.0):
				StageManager.restore_camera_zoom.emit()
				effect_done = true
		time_elapsed += delta

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	time_elapsed = 0
	camera_zoom_changed = false
	effect_done = false
