extends ActionableState
class_name StateMoveBkwd


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/movebackward"


func enter():
	super.enter()
	if animName in animList:
		animPlayer.play(animName)


func exit():
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	owner.velocity.x = -(owner.spd * owner.backwardSpdMult * %SideTracker.side)
