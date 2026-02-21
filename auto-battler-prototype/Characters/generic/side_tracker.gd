extends Node2D

var side = 1        # 1 = right, -1 = left
var canFlip = true

func _ready() -> void:
	side = 1 if scale.x > 0 else -1

func set_facing_direction(facingRight: bool):
	if canFlip:
		if facingRight:
			side = 1
			scale.x = 1
		else:
			side = -1
			scale.x = -1
	

func set_lock_direction(directionLock: bool):
	canFlip = !directionLock
