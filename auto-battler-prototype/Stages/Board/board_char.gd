extends CharacterBody2D

@export var initialNode : MapNode
@onready var currentNode : MapNode


func _ready() -> void:
	position = initialNode.position
	currentNode = initialNode


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		#position.x -= 64
		if currentNode.leftNode:
			currentNode = currentNode.leftNode
			position = currentNode.position
	elif Input.is_action_just_pressed("ui_down"):
		#position.y += 64
		if currentNode.downNode:
			currentNode = currentNode.downNode
			position = currentNode.position
	elif Input.is_action_just_pressed("ui_right"):
		#position.x += 64
		if currentNode.rightNode:
			currentNode = currentNode.rightNode
			position = currentNode.position
	elif Input.is_action_just_pressed("ui_up"):
		#position.y -= 64
		if currentNode.upNode:
			currentNode = currentNode.upNode
			position = currentNode.position
	
	
