extends Node

signal changeCameraFocus(targets : Array)
signal restoreOriginalFocus()

signal changeCameraZoom(value : Vector2)
signal restoreCameraZoom()

@onready var currentStage : Stage
@onready var originalTargets : Array


func _ready() -> void:
	changeCameraFocus.connect(_on_camera_focus_change)
	restoreOriginalFocus.connect(_on_camera_focus_reverted)
	changeCameraZoom.connect(_on_camera_zoom_set)
	restoreCameraZoom.connect(_on_camera_zoom_restored)

func set_stage(stage : Stage) -> void:
	currentStage = stage
	var phanCam : PhantomCamera2D = currentStage.get_node("PhanCam")
	originalTargets = phanCam.follow_targets

func _on_camera_focus_change(targets : Array) -> void:
	var phanCam : PhantomCamera2D = currentStage.get_node("PhanCam")
	var setTargets : Array[Node2D] = []
	for target in targets:
		if target is Node2D:
			setTargets.append(target)
	phanCam.set_follow_targets(setTargets)

func _on_camera_focus_reverted() -> void:
	var phanCam : PhantomCamera2D = currentStage.get_node("PhanCam")
	phanCam.set_follow_targets(originalTargets)

func _on_camera_zoom_set(value : Vector2) -> void:
	var phanCam : PhantomCamera2D = currentStage.get_node("PhanCam")
	phanCam.auto_zoom = false
	var zoomTween : Tween = create_tween()
	zoomTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	zoomTween.tween_property(currentStage.get_node("Runner/Camera"), "zoom", value, 0.1)
	phanCam.set_zoom(value)

func _on_camera_zoom_restored() -> void:
	var phanCam : PhantomCamera2D = currentStage.get_node("PhanCam")
	phanCam.auto_zoom = true
