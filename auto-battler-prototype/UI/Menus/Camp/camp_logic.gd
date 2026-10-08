extends Node


func _on_rest_btn_pressed() -> void:
	CurrentRunData.current_hp = CurrentRunData.char_data.maxHP
	%MapStateMachine.on_child_transition(%MapStateMachine.currentState, "Map")


func _on_spar_btn_pressed() -> void:
	var battleSetupScene : PackedScene = load("res://UI/Menus/Battle/BattleSetup.tscn")
	var battleSetupNode = battleSetupScene.instantiate()
	get_tree().change_scene_to_node(battleSetupNode)
