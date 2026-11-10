class_name StateClashWin
extends State

var anim_list : PackedStringArray = []
var anim_name : String
@onready var anim_player : AnimationPlayer = %AnimationPlayer

func _ready():
	anim_list = anim_player.get_animation_list()
	anim_name = owner.anim_lib_name + "/clashwin"

func enter():
	owner.can_clash = false
	if anim_name in anim_list:
		anim_player.play(anim_name)
	var vfx_pos : Vector2 = owner.opponent.global_position
	VFXManager.spawn_vfx(VFXManager.VFXType.CLASHWIN, vfx_pos, owner.get_side())


func exit():
	anim_player.stop()


func update(_delta: float):
	pass
	#currentDuration += _delta
	#if currentDuration >= animDuration:
		#transition.emit(self, "Idle")


func physics_update(_delta: float):
	pass


func _on_animation_player_animation_finished(animation_name: StringName) -> void:
	if animation_name == anim_name:
		transition.emit(self, "Idle")
