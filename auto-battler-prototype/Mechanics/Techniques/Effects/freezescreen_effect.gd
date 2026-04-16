extends Effect
class_name FreezeScreenEffect

@onready var character : Character
@export var applyFrame : int
@export var revertFrame : int
@onready var timeElapsed : float = 0
@onready var freezeScreen : bool = false
@onready var prevProcessMode : ProcessMode
@onready var effectDone : bool = false

func execute_effect(delta: float) -> void:
	if not effectDone:
		if not freezeScreen:
			if timeElapsed > (applyFrame / 60.0):
				prevProcessMode = character.process_mode
				character.process_mode = Node.PROCESS_MODE_ALWAYS
				get_tree().paused = true
				freezeScreen = true
		else:
			if timeElapsed > (revertFrame / 60.0):
				get_tree().paused = false
				character.process_mode = prevProcessMode
				freezeScreen = false
				effectDone = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	timeElapsed = 0
	freezeScreen = false
	effectDone = false
