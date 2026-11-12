class_name MoveEffect
extends Effect

@export var velocity : Vector2
@export var apply_frame : int

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var triggered : bool = false

func execute_effect(_delta: float) -> void:
	pass

func execute_physics_effect(delta: float) -> void:
	if not triggered:
		if time_elapsed > (apply_frame / 60.0):
			character.velocity += velocity * character.get_side()
			triggered = true
		time_elapsed += delta

func reset() -> void:
	time_elapsed = 0
	triggered = false
