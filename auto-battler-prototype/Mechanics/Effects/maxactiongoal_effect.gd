extends Effect
class_name MaxActionGoalEffect

@onready var character : Character
@onready var triggered : bool = false

func execute_effect(delta: float) -> void:
	if not triggered:
		character.currentActionGoal = max(character.currentActionGoal, character.actionGoalTotal)
		triggered = true

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	triggered = false
