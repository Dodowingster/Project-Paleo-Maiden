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
		get_tree().paused = !get_tree().paused
		%PauseMenu.visible = !%PauseMenu.visible


func _on_resume_btn_pressed() -> void:
	get_tree().paused = !get_tree().paused
	%PauseMenu.visible = !%PauseMenu.visible


func _on_end_battle_btn_pressed() -> void:
	get_tree().paused = false
	var battleSetup : PackedScene = load("res://UI/Menus/BattleSetup.tscn")
	var battleSetupNode : Node = battleSetup.instantiate()
	get_tree().change_scene_to_node(battleSetupNode)
