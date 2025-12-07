extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3

func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity * _delta
	move_and_slide()

func _physics_process(delta: float) -> void:
	set_char_velocity(delta)
