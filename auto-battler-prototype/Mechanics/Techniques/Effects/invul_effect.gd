extends Effect
class_name InvulEffect

@onready var character : Character
@export var applyFrame : int
@export var revertFrame : int
@onready var timeElapsed : float = 0
@onready var hurtboxDisabled : bool = false
@onready var effectDone : bool = false

func execute_effect(delta: float) -> void:
	if not effectDone:
		if not hurtboxDisabled:
			if timeElapsed > (applyFrame / 60.0):
				character.toggle_hurtbox(false)
				hurtboxDisabled = true
		else:
			if timeElapsed > (revertFrame / 60.0):
				character.toggle_hurtbox(true)
				hurtboxDisabled = false
				effectDone = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	character.toggle_collision(true)
	timeElapsed = 0
	hurtboxDisabled = false
	effectDone = false
