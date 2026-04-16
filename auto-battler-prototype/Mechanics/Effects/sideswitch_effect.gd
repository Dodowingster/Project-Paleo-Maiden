extends Effect
class_name SideSwitchEffect

@onready var character : Character
@export var applyFrame : int
@export var revertFrame : int
@onready var timeElapsed : float = 0
@onready var colDisabled : bool = false
@onready var effectDone : bool = false

func execute_effect(delta: float) -> void:
	if not effectDone:
		if not colDisabled:
			if timeElapsed > (applyFrame / 60.0):
				character.toggle_collision(false)
				colDisabled = true
		else:
			if timeElapsed > (revertFrame / 60.0):
				character.toggle_collision(true)
				colDisabled = false
				effectDone = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	character.toggle_collision(true)
	timeElapsed = 0
	colDisabled = false
	effectDone = false
