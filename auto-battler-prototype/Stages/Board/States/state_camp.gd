extends State
class_name StateCamp


func enter():
	CurrentRunData.current_map_action = GlobalValues.MAPACTION.CAMP
	%CampOptionsPanel.visible = true
	%CampOptionsPanel.get_node("CampOptions/SparBtn").disabled = !can_spar()
	%MapComponents.visible = false
	%CharDisplay.update_ui()

func exit():
	%CampOptionsPanel.visible = false
	%MapComponents.visible = true


func can_spar() -> bool:
	var result = false
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
					result = true
					break
	return result
