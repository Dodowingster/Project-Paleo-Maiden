class_name HitBox
extends Area2D

signal hit_detected()

@export var damage = 10
@export var hitstun : float = 0.15
@export var blockstun : float = 0.12
@export var knockback_x = 0
@export var knockback_y = 0
@export var blockback_x = 0
@export var blockback_y = 0
@export var hitstop_frames = 0
@export var is_multi_hit = false
# if grouped, then only one of these hitboxes can hit a hurtbox at one times
@export var group_name = ""
@onready var entered_areas : Array[Area2D] = []

func _init() -> void:
	collision_layer = 2
	collision_mask = 4

#func _physics_process(_delta: float) -> void:
	#var canDetect = false
	#var hitboxShapes : Array = get_children()
	#for shape in hitboxShapes:
		#if shape is CollisionShape2D:
			#if !shape.disabled:
				#canDetect = true
	#
	#if !canDetect:
		#entered_areas = []
	#else:
		#var areas = get_overlapping_areas()
		#for area in areas:
			#if area is Hurtbox and (entered_areas.find(area) == -1):
				#area.on_area_entered(self)
				#entered_areas.append(area)
