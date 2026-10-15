extends Control


func _on_resume_btn_pressed() -> void:
	var rootNode = get_tree().current_scene
	if rootNode is Stage:
		rootNode.resume_game()
		self.visible = false


func _on_restart_btn_pressed() -> void:
	var rootNode = get_tree().current_scene
	if rootNode is Stage:
		rootNode.restart_game()


func _on_end_battle_btn_pressed() -> void:
	var rootNode = get_tree().current_scene
	if rootNode is Stage:
		rootNode._on_end_battle_btn_pressed()
