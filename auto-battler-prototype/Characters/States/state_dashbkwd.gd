extends DashState
class_name StateDashBkwd


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String
var backupAnim : String

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/dashbackward"
	backupAnim = owner.animLibName + "/movebackward"


func enter():
	super.enter()
	if animName in animList:
		animPlayer.play(animName)
	else:
		if backupAnim in animList:
			animPlayer.play(backupAnim)


func exit():
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	owner.velocity.x = -(owner.spd * owner.backwardDashSpdMult * %SideTracker.side)
