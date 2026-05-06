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
@export var isMultiHit = false
# if grouped, then only one of these hitboxes can hit a hurtbox at one times
@export var groupName = ""
@onready var enteredAreas : Array[Area2D] = []

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
		#enteredAreas = []
	#else:
		#var areas = get_overlapping_areas()
		#for area in areas:
			#if area is Hurtbox and (enteredAreas.find(area) == -1):
				#area.on_area_entered(self)
				#enteredAreas.append(area)
