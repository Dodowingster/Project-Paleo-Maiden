extends Control


func _on_resume_btn_pressed() -> void:
	var root_node = get_tree().current_scene
	if root_node is Stage:
		root_node.resume_game()
		self.visible = false


func _on_restart_btn_pressed() -> void:
	var root_node = get_tree().current_scene
	if root_node is Stage:
		root_node.restart_game()


func _on_end_battle_btn_pressed() -> void:
	var root_node = get_tree().current_scene
	if root_node is Stage:
		root_node._on_end_battle_btn_pressed()
