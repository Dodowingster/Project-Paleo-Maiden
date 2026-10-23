extends CharacterBody2D
class_name MapPlayer

signal broadcastScoutValue(value : int)

@export var initialNode : MapNode
@onready var currentNode : MapNode : 
	set(value):
		currentNode = value
		CurrentRunData.current_node_id = value.nodeID
@onready var scout_value = 0 :
	get:
		return scout_value
	set(value):
		broadcastScoutValue.emit(value)
		scout_value = value
@onready var scout_path : Array[MapNode]
@onready var can_move : bool = true


func _ready() -> void:
	if CurrentRunData.current_node_id != -1:
		for mapNode in %MapNodeCollection.get_children():
			if mapNode is MapNode:
				if CurrentRunData.current_node_id == mapNode.nodeID:
					initialNode = mapNode
					break
	position = initialNode.position
	currentNode = initialNode
	
	can_move = true


func _process(_delta: float) -> void:
	if can_move and CurrentRunData.current_map_action == GlobalValues.MAPACTION.MOVE:
		move()

func move() -> void:
	var moved : bool = false
	if Input.is_action_just_pressed("ui_left"):
		if currentNode.leftNode:
			if is_move_valid(currentNode.leftNode):
				currentNode = currentNode.leftNode
				moved = true
	elif Input.is_action_just_pressed("ui_down"):
		if currentNode.downNode:
			if is_move_valid(currentNode.downNode):
				currentNode = currentNode.downNode
				moved = true
	elif Input.is_action_just_pressed("ui_right"):
		if currentNode.rightNode:
			if is_move_valid(currentNode.rightNode):
				currentNode = currentNode.rightNode
				moved = true
	elif Input.is_action_just_pressed("ui_up"):
		if currentNode.upNode:
			if is_move_valid(currentNode.upNode):
				currentNode = currentNode.upNode
				moved = true
	if moved:
		position = currentNode.position
		process_move()

func scout_initialize_move(value : int) -> void:
	scout_value = value
	scout_path.clear()
	scout_path.append(currentNode)

func process_move() -> void:
	var current_node_index = scout_path.find(currentNode)
	if current_node_index == -1:
		scout_path.append(currentNode)
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
