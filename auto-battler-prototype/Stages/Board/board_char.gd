extends CharacterBody2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		position.x -= 64
	elif Input.is_action_just_pressed("ui_down"):
		position.y += 64
	elif Input.is_action_just_pressed("ui_right"):
		position.x += 64
	elif Input.is_action_just_pressed("ui_up"):
		position.y -= 64
