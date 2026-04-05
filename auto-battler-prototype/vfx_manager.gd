extends Node

@onready var hit_vfx : PackedScene = preload("res://VFX/GenericHit.tscn")
@onready var block_vfx : PackedScene = preload("res://VFX/GenericBlock.tscn")
@onready var clashwin_vfx : PackedScene = preload("res://VFX/GenericClashWin.tscn")
@onready var clash_vfx : PackedScene = preload("res://VFX/GenericClashing.tscn")
@onready var bothClash : bool = false

enum VFX_TYPE { HIT, BLOCK, CLASHWIN }

func spawn_vfx(vfx_type : VFX_TYPE, vfx_position : Vector2, scale_x_mod : int = 1) -> VFX:
	var vfx_node : VFX
	match vfx_type:
		VFX_TYPE.HIT:
			vfx_node = hit_vfx.instantiate()
		VFX_TYPE.BLOCK:
			vfx_node = block_vfx.instantiate()
		VFX_TYPE.CLASHWIN:
			vfx_node = clashwin_vfx.instantiate()
		_:
			push_error("VFX doesn't exist.")
	vfx_node.add_to_group("vfx")
	vfx_node.global_position = vfx_position
	vfx_node.scale.x = vfx_node.scale.x * scale_x_mod
	get_tree().root.add_child(vfx_node, false)
	return vfx_node

func spawn_specified_vfx(vfx : VFX, vfx_position : Vector2, scale_x_mod : int = 1) -> VFX:
	vfx.position = vfx_position
	vfx.scale.x = vfx.scale.x * scale_x_mod
	get_tree().root.add_child(vfx)
	return vfx

func spawn_clash_vfx(char1 : Character, char2 : Character) -> Node2D:
	# method needs to be called twice to spawn the vfx
	if !bothClash:
		bothClash = true
		return null
	else:
		var clash_node : Node2D = clash_vfx.instantiate()
		var vfx_position : Vector2 = (char1.global_position + char2.global_position) / 2.0
		clash_node.global_position = vfx_position
		clash_node.add_to_group("vfx", false)
		get_tree().root.add_child(clash_node)
		return clash_node

func despawn_clash_vfx(clash_node : Node2D) -> void:
	bothClash = false
	clash_node.queue_free()
