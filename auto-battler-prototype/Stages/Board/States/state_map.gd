extends State
class_name StateMap


func enter():
	%MiniMenu.visible = true
	%MapComponents.visible = true

func exit():
	%MiniMenu.visible = false
	%MapComponents.visible = false
