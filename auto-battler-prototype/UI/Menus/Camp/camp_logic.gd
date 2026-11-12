extends Node


func _on_rest_btn_pressed() -> void:
	CurrentRunData.char_data.current_hp = CurrentRunData.char_data.max_hp
	%MapStateMachine.on_child_transition(%MapStateMachine.current_state, "Map")


func _on_spar_btn_pressed() -> void:
	var battleSetupScene : PackedScene = load("res://UI/Menus/Battle/BattleSetup2.tscn")
	var battleSetupNode : BattlePreview = battleSetupScene.instantiate()
	
	battleSetupNode.char1 = CurrentRunData.char_data
	battleSetupNode.loadout1 = CurrentRunData.technique_loadout.get_list()
	
	var currentNode : MapNode = null
	for mapNode in %MapNodeCollection.get_children():
		if mapNode is MapNode:
			if CurrentRunData.current_node_id == mapNode.nodeID:
				currentNode = mapNode
				break
	
	if currentNode != null:
		var mapNodeChildren : Array[Node] = currentNode.get_children()
		if mapNodeChildren.size() >= 1:
			for child in mapNodeChildren:
				if child is EnemyData:
					battleSetupNode.char2 = child.base_character.duplicate_deep()
					battleSetupNode.char2.atk = child.atk
					battleSetupNode.char2.def = child.def
					battleSetupNode.char2.spd = child.spd
					battleSetupNode.char2.min_sta = child.min_sta
					battleSetupNode.char2.max_sta = child.max_sta
					battleSetupNode.char2.max_hp = child.max_hp
					battleSetupNode.char2.current_hp = child.current_hp
					battleSetupNode.loadout2 = child.loadout.duplicate_deep()
	
		get_tree().change_scene_to_node(battleSetupNode)
	else:
		print("Current node is null")


func _on_train_btn_pressed() -> void:
	RewardsManager.reward_technique(CurrentRunData.char_data.character_name)
	%MapStateMachine.on_child_transition(%MapStateMachine.current_state, "Map")
