class_name SurviveEffect
extends Effect

@onready var character : Character
@onready var triggered : bool = false

func execute_effect(_delta: float) -> void:
	if not triggered:
		character.health = 1
		triggered = true

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	triggered = false
