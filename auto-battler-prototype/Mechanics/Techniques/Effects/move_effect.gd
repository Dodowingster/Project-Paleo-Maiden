extends Effect
class_name MoveEffect

@onready var character : Character
@export var velocity : Vector2
@export var applyFrame : int
@onready var timeElapsed : float = 0
@onready var triggered : bool = false

func execute_effect(delta: float) -> void:
	pass

func execute_physics_effect(delta: float) -> void:
	if not triggered:
		timeElapsed += delta
		if timeElapsed > (applyFrame / 60.0):
			character.velocity += velocity * character.get_side()
			triggered = true

func reset() -> void:
	timeElapsed = 0
	triggered = false
