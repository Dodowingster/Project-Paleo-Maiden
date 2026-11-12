class_name SideTracker
extends Node2D

var side = 1        # 1 = right, -1 = left
var can_flip = true

func _ready() -> void:
	side = 1 if scale.x > 0 else -1

func set_facing_direction(facing_right: bool):
	if facing_right:
		side = 1
		scale.x = 1
	else:
		side = -1
		scale.x = -1


func set_side_lock(direction_lock: bool):
	can_flip = !direction_lock
