extends Node2D
class_name Map

@onready var paused : bool = false


func _ready() -> void:
	paused = false


func setup():
	if CurrentRunData.current_map_action == GlobalValues.MapAction.CAMP:
		%MapStateMachine.initial_state = %Camp
	elif CurrentRunData.current_map_action == GlobalValues.MapAction.SCOUT:
		%MapStateMachine.initial_state = %Map
	elif CurrentRunData.current_map_action == GlobalValues.MapAction.MOVE:
		%MapStateMachine.initial_state = %Move

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		if not paused:
			paused = true
			set_player_can_move(false)
			%UI.visible = false
			%CharUI.visible = true
		else:
			paused = false
			set_player_can_move(true)
			%UI.visible = true
			%CharUI.visible = false

func set_player_can_move(canMove : bool):
	for child in %MapComponents.get_children():
		if child is MapPlayer:
			child.can_move = canMove
