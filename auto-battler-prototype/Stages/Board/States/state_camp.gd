extends State
class_name StateCamp


func enter():
	CurrentRunData.current_map_action = GlobalValues.MAPACTION.CAMP
	%CampOptionsPanel.visible = true
	%CampOptionsPanel.get_node("CampOptions/SparBtn").disabled = !can_spar()

func exit():
	%CampOptionsPanel.visible = false


func can_spar() -> bool:
	var result = false
	var mapNodeChildren : Array[Node] = CurrentRunData.current_node.get_children()
	if mapNodeChildren.size() >= 1:
		for child in mapNodeChildren:
			if child is EnemyData:
				result = true
				break
	return result
