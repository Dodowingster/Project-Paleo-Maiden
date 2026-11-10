class_name StateDashFwd
extends DashState

var anim_list : PackedStringArray = []
var anim_name : String
var backup_anim : String

@onready var anim_player : AnimationPlayer = %AnimationPlayer

func _ready():
	anim_list = anim_player.get_animation_list()
	anim_name = owner.anim_lib_name + "/dashforward"
	backup_anim = owner.anim_lib_name + "/moveforward"


func enter():
	super.enter()
	if anim_name in anim_list:
		anim_player.play(anim_name)
	else:
		if backup_anim in anim_list:
			anim_player.play(backup_anim)
	var vfx_pos : Vector2 = owner.global_position
	VFXManager.spawn_vfx(VFXManager.VFXType.DASH, vfx_pos, owner.get_side())


func exit():
	anim_player.play(owner.anim_lib_name + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	owner.velocity.x = owner.spd * owner.forward_dash_spd_mult * %SideTracker.side
