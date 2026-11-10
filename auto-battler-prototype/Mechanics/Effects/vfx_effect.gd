class_name VFXEffect
extends Effect

@export var vfx : PackedScene
@export var local_pos : Vector2 = Vector2(0, 0)
@export var apply_frame : int

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var triggered : bool = false

func execute_effect(delta: float) -> void:
	if not triggered:
		if time_elapsed > (apply_frame / 60.0):
			var vfx_node = vfx.instantiate()
			if vfx_node is VFX:
				vfx_node.process_mode = Node.PROCESS_MODE_ALWAYS
				var side_corrected_pos : Vector2 = Vector2(local_pos.x * character.get_side(), local_pos.y)
				var vfx_pos : Vector2 = character.global_position + side_corrected_pos
				var in_tree_vfx : VFX = VFXManager.spawn_specified_vfx(vfx_node, vfx_pos, character.get_side())
			triggered = true
		time_elapsed += delta

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	time_elapsed = 0
	triggered = false
