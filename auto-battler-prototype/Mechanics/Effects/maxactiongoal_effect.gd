class_name MaxActionGoalEffect
extends Effect

@onready var character : Character
@onready var triggered : bool = false

func execute_effect(_delta: float) -> void:
	if not triggered:
		character.current_action_goal = max(character.current_action_goal, character.action_goal_total)
		triggered = true

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	triggered = false
