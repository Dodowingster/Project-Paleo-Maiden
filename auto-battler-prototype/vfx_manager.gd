extends Node

@onready var hit_vfx : PackedScene = preload("res://VFX/GenericHit.tscn")
@onready var block_vfx : PackedScene = preload("res://VFX/GenericBlock.tscn")

enum VFX_TYPE { HIT, BLOCK }

func spawn_vfx(vfx_type : VFX_TYPE, vfx_position : Vector2, scale_x_mod : int = 1) -> VFX:
	var vfx_node : VFX
	match vfx_type:
		VFX_TYPE.HIT:
			vfx_node = hit_vfx.instantiate()
		VFX_TYPE.BLOCK:
			vfx_node = block_vfx.instantiate()
		_:
			push_error("VFX doesn't exist.")
	vfx_node.add_to_group("vfx")
	vfx_node.position = vfx_position
	vfx_node.scale.x = vfx_node.scale.x * scale_x_mod
	get_tree().root.add_child(vfx_node)
	return vfx_node
