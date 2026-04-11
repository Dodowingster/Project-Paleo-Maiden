extends Effect
class_name ZoomCameraEffect

@onready var character : Character
@export var applyFrame : int
@export var revertFrame : int
@export var zoom : Vector2 = Vector2(1, 1)
@onready var timeElapsed : float = 0
@onready var cameraZoomChanged : bool = false
@onready var effectDone : bool = false

func execute_effect(delta: float) -> void:
	if not effectDone:
		if not cameraZoomChanged:
			if timeElapsed > (applyFrame / 60.0):
				StageManager.changeCameraZoom.emit(zoom)
				cameraZoomChanged = true
		else:
			if timeElapsed > (revertFrame / 60.0):
				StageManager.restoreCameraZoom.emit()
				effectDone = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	timeElapsed = 0
	cameraZoomChanged = false
	effectDone = false
