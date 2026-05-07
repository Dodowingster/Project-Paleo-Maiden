extends DashState
class_name StateDashFwd


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/moveforward"

func enter():
	super.enter()
	if animName in animList:
		animPlayer.play(animName)
	var vfx_pos : Vector2 = owner.global_position
	VFXManager.spawn_vfx(VFXManager.VFX_TYPE.DASH, vfx_pos, owner.get_side())


func exit():
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	owner.velocity.x = owner.spd * owner.forwardDashSpdMult * %SideTracker.side
