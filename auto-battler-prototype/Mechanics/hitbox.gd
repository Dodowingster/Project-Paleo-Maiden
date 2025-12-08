class_name HitBox
extends Area2D

@export var damage = 10
@export var hitstun : float = 0.15
@export var knockbackX = 0
@export var knockbackY = 0
@export var hitboxArea : CollisionShape2D
@export var isMultiHit = false


# if grouped, then only one of these hitboxes can hit a hurtbox at one times
@export var groupName = ""

func _init() -> void:
	collision_layer = 2
	collision_mask = 4
	
