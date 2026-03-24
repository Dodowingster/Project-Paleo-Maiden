extends Node2D
class_name Stage

var frame_forward_pressed : bool = false

func _physics_process(_delta: float) -> void:
	if get_tree().paused:
		if frame_forward_pressed:
			get_tree().paused = false
		if Input.is_action_just_pressed("frame_forward"):
			frame_forward_pressed = true
	else:
		if frame_forward_pressed:
			get_tree().paused = true
			frame_forward_pressed = false
	
	if Input.is_action_just_pressed("pause_action"):
		if !%PauseMenu.visible:
			get_tree().paused = !get_tree().paused
	
	if Input.is_action_just_pressed("pause_menu"):
		if %PauseMenu.visible:
			get_tree().paused = false
			%PauseMenu.visible = false
		else:
			get_tree().paused = true
			%PauseMenu.visible = true


func _on_resume_btn_pressed() -> void:
	get_tree().paused = !get_tree().paused
	%PauseMenu.visible = !%PauseMenu.visible


func _on_end_battle_btn_pressed() -> void:
	get_tree().paused = false
	SimpleSceneManager.back_to_battle_setup(self)
	
