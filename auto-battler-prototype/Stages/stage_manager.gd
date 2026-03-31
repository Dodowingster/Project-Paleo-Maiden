extends Node

signal changeCameraFocus(targets : Array)
signal restoreOriginalFocus()

@onready var currentStage : Stage
@onready var originalTargets : Array


func _ready() -> void:
	changeCameraFocus.connect(_on_camera_focus_change)
	restoreOriginalFocus.connect(_on_camera_focus_reverted)

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
