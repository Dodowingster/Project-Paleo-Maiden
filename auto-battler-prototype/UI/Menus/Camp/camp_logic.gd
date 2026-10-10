extends Node


func _on_rest_btn_pressed() -> void:
	CurrentRunData.current_hp = CurrentRunData.char_data.maxHP
	%MapStateMachine.on_child_transition(%MapStateMachine.currentState, "Map")


func _on_spar_btn_pressed() -> void:
	var battleSetupScene : PackedScene = load("res://UI/Menus/Battle/BattleSetup2.tscn")
	var battleSetupNode : BattlePreview = battleSetupScene.instantiate()
	
	battleSetupNode.char1 = CurrentRunData.char_data
	battleSetupNode.loadout1 = CurrentRunData.technique_loadout
	
	battleSetupNode.char2 = CurrentRunData.char_data.duplicate_deep()
	battleSetupNode.loadout2 = CurrentRunData.technique_loadout.duplicate_deep()
	
	get_tree().change_scene_to_node(battleSetupNode)
	
