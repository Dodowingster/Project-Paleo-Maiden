extends Node

signal change_camera_focus(targets : Array)
signal restore_original_focus()

signal change_camera_zoom(value : Vector2)
signal restore_camera_zoom()

@onready var current_stage : Stage
@onready var original_targets : Array


func _ready() -> void:
	change_camera_focus.connect(_on_camera_focus_change)
	restore_original_focus.connect(_on_camera_focus_reverted)
	change_camera_zoom.connect(_on_camera_zoom_set)
	restore_camera_zoom.connect(_on_camera_zoom_restored)

func set_stage(stage : Stage) -> void:
	current_stage = stage
	var phan_cam : PhantomCamera2D = current_stage.get_node("PhanCam")
	original_targets = phan_cam.follow_targets

func _on_camera_focus_change(targets : Array) -> void:
	var phan_cam : PhantomCamera2D = current_stage.get_node("PhanCam")
	var set_targets : Array[Node2D] = []
	for target in targets:
		if target is Node2D:
			set_targets.append(target)
	phan_cam.set_follow_targets(set_targets)

func _on_camera_focus_reverted() -> void:
	var phan_cam : PhantomCamera2D = current_stage.get_node("PhanCam")
	phan_cam.set_follow_targets(original_targets)

func _on_camera_zoom_set(value : Vector2) -> void:
	var phan_cam : PhantomCamera2D = current_stage.get_node("PhanCam")
	phan_cam.auto_zoom = false
	var zoom_tween : Tween = create_tween()
	zoom_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	zoom_tween.tween_property(current_stage.get_node("Runner/Camera"), "zoom", value, 0.1)
	phan_cam.set_zoom(value)

func _on_camera_zoom_restored() -> void:
	var phan_cam : PhantomCamera2D = current_stage.get_node("PhanCam")
	phan_cam.auto_zoom = true
