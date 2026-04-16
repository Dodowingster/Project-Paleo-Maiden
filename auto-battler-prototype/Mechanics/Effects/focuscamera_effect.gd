extends Effect
class_name FocusCameraEffect

@onready var character : Character
@export var applyFrame : int
@export var revertFrame : int
@onready var timeElapsed : float = 0
@onready var cameraFocusChanged : bool = false
@onready var prevProcessMode : ProcessMode
@onready var effectDone : bool = false

func execute_effect(delta: float) -> void:
	if not effectDone:
		if not cameraFocusChanged:
			if timeElapsed > (applyFrame / 60.0):
				StageManager.changeCameraFocus.emit([character])
				cameraFocusChanged = true
		else:
			if timeElapsed > (revertFrame / 60.0):
				StageManager.restoreOriginalFocus.emit()
				effectDone = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	timeElapsed = 0
	cameraFocusChanged = false
	effectDone = false
