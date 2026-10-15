extends Node2D
class_name Map

func _ready() -> void:
	pass


func setup():
	if CurrentRunData.current_map_action == GlobalValues.MAPACTION.CAMP:
		%MapStateMachine.on_child_transition(%MapStateMachine.currentState, "Camp")
	elif CurrentRunData.current_map_action == GlobalValues.MAPACTION.SCOUT:
		%MapStateMachine.on_child_transition(%MapStateMachine.currentState, "Scout")
	elif CurrentRunData.current_map_action == GlobalValues.MAPACTION.MOVE:
		%MapStateMachine.on_child_transition(%MapStateMachine.currentState, "Move")
