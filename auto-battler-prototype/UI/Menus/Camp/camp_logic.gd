extends Node


func _on_rest_btn_pressed() -> void:
	CurrentRunData.char_data.currentHP = CurrentRunData.char_data.maxHP
	%MapStateMachine.on_child_transition(%MapStateMachine.currentState, "Map")


func _on_spar_btn_pressed() -> void:
	var battleSetupScene : PackedScene = load("res://UI/Menus/Battle/BattleSetup2.tscn")
	var battleSetupNode : BattlePreview = battleSetupScene.instantiate()
	
	battleSetupNode.char1 = CurrentRunData.char_data
	battleSetupNode.loadout1 = CurrentRunData.technique_loadout
	
	var mapNodeChildren : Array[Node] = CurrentRunData.current_node.get_children()
	if mapNodeChildren.size() >= 1:
		for child in mapNodeChildren:
			if child is EnemyData:
				battleSetupNode.char2 = child.baseCharacter.duplicate_deep()
				battleSetupNode.char2.atk = child.atk
				battleSetupNode.char2.def = child.def
				battleSetupNode.char2.spd = child.spd
				battleSetupNode.char2.minSta = child.minSta
				battleSetupNode.char2.maxSta = child.maxSta
				battleSetupNode.char2.maxHP = child.maxHP
				battleSetupNode.char2.currentHP = child.currentHP
				battleSetupNode.loadout2 = child.loadout.duplicate_deep()
	
	#battleSetupNode.char2 = CurrentRunData.char_data.duplicate_deep()
	#battleSetupNode.loadout2 = CurrentRunData.technique_loadout.duplicate_deep()
	
	get_tree().change_scene_to_node(battleSetupNode)
