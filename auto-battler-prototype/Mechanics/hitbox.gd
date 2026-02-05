class_name HitBox
extends Area2D

@export var damage = 10
@export var hitstun : float = 0.15
@export var blockstun : float = 0.12
@export var knockbackX = 0
@export var knockbackY = 0
@export var blockbackX = 0
@export var blockbackY = 0
@export var hitstopFrames = 0
@export var hitboxAreaList : Array[CollisionShape2D]
@export var isMultiHit = false


# if grouped, then only one of these hitboxes can hit a hurtbox at one times
@export var groupName = ""

func _init() -> void:
	collision_layer = 2
	collision_mask = 4
	
