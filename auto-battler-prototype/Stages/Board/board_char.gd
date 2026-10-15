extends CharacterBody2D
class_name MapPlayer

signal broadcastScoutValue(value : int)

@export var initialNode : MapNode
#@onready var currentNode : MapNode : 
	#set(mapNode):
		#currentNode = mapNode
		#CurrentRunData.current_node = mapNode
#@onready var currentAction : GlobalValues.MAPACTION
@onready var scout_value = 0 :
	get:
		return scout_value
	set(value):
		broadcastScoutValue.emit(value)
		scout_value = value
@onready var scout_path : Array[MapNode]


func _ready() -> void:
	position = initialNode.position
	CurrentRunData.current_node = initialNode


func _process(_delta: float) -> void:
	if CurrentRunData.current_map_action == GlobalValues.MAPACTION.MOVE:
		move()

func move() -> void:
	var moved : bool = false
	if Input.is_action_just_pressed("ui_left"):
		if CurrentRunData.current_node.leftNode:
			if is_move_valid(CurrentRunData.current_node.leftNode):
				CurrentRunData.current_node = CurrentRunData.current_node.leftNode
				moved = true
	elif Input.is_action_just_pressed("ui_down"):
		if CurrentRunData.current_node.downNode:
			if is_move_valid(CurrentRunData.current_node.downNode):
				CurrentRunData.current_node = CurrentRunData.current_node.downNode
				moved = true
	elif Input.is_action_just_pressed("ui_right"):
		if CurrentRunData.current_node.rightNode:
			if is_move_valid(CurrentRunData.current_node.rightNode):
				CurrentRunData.current_node = CurrentRunData.current_node.rightNode
				moved = true
	elif Input.is_action_just_pressed("ui_up"):
		if CurrentRunData.current_node.upNode:
			if is_move_valid(CurrentRunData.current_node.upNode):
				CurrentRunData.current_node = CurrentRunData.current_node.upNode
				moved = true
	if moved:
		position = CurrentRunData.current_node.position
		process_move()

func scout_initialize_move(value : int) -> void:
	scout_value = value
	scout_path.clear()
	scout_path.append(CurrentRunData.current_node)

func process_move() -> void:
	var current_node_index = scout_path.find(CurrentRunData.current_node)
	if current_node_index == -1:
		scout_path.append(CurrentRunData.current_node)
		scout_value -= 1
	else:
		var popout_count = scout_path.size() - (current_node_index + 1)
		for i in range(popout_count):
			scout_path.pop_back()
		scout_value += popout_count

func is_move_valid(mapNode : MapNode) -> bool:
	var valid = false
	if scout_value > 0:
		valid = true
	else:
		if scout_path.find(mapNode) >= 0:
			valid = true
	return valid

func end_move() -> void:
	scout_value = 0
	scout_path.clear()
