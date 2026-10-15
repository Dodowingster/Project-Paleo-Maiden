extends Control

func _on_rematch_btn_pressed() -> void:
	var rootNode = get_tree().current_scene
	if rootNode is Stage:
		rootNode.restart_game()


func _on_end_battle_btn_pressed() -> void:
	var rootNode = get_tree().current_scene
	if rootNode is Stage:
		rootNode._on_end_battle_btn_pressed()
