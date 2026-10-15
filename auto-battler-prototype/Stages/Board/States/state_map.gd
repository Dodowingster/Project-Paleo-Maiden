extends State
class_name StateMap


func enter():
	CurrentRunData.current_map_action = GlobalValues.MAPACTION.SCOUT
	%MiniMenu.visible = true
	%MiniMenu.get_node("EndMoveButton").visible = false
	%MapComponents.visible = true

func exit():
	%MiniMenu.get_node("EndMoveButton").visible = true
	%MiniMenu.visible = false
	%MapComponents.visible = false
