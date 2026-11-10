class_name GoodClashEffect
extends Effect

@onready var character : Character
@onready var triggered : bool = false

func execute_effect(_delta: float) -> void:
	if not triggered:
		character.clash_result = true
		character.opponent.clash_result = false
		triggered = true

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	triggered = false
