extends Effect
class_name VFXEffect

@onready var character : Character
@export var vfx : PackedScene
@export var localPos : Vector2 = Vector2(0, 0)
@export var applyFrame : int
@onready var timeElapsed : float = 0
@onready var triggered : bool = false

func execute_effect(delta: float) -> void:
	if not triggered:
		if timeElapsed > (applyFrame / 60.0):
			var vfxNode = vfx.instantiate()
			if vfxNode is VFX:
				vfxNode.process_mode = Node.PROCESS_MODE_ALWAYS
				var side_corrected_pos : Vector2 = Vector2(localPos.x * character.get_side(), localPos.y)
				var vfx_pos : Vector2 = character.global_position + side_corrected_pos
				var in_tree_vfx : VFX = VFXManager.spawn_specified_vfx(vfxNode, vfx_pos, character.get_side())
			triggered = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	timeElapsed = 0
	triggered = false
