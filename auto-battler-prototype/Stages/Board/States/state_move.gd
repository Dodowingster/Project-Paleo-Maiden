extends State
class_name StateMove


func enter():
	CurrentRunData.current_map_action = GlobalValues.MAPACTION.MOVE
	%MiniMenu.visible = true
	%MiniMenu.get_node("ScoutButton").visible = false
	%MapComponents.visible = true
	%CharDisplay.update_ui()

func exit():
	%MiniMenu.get_node("ScoutButton").visible = true
	%MiniMenu.visible = false
	%MapComponents.visible = false
