extends ActionableState
class_name StateMoveBkwd


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String
var lastTick : int = 0

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/movebackward"


func enter():
	owner.canClash = true
	if animName in animList:
		animPlayer.play(animName)


func exit():
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	if lastTick != owner.tickCount:
		lastTick = owner.tickCount
		owner.position.x -= owner.spd * owner.backwardSpdMult * %SideTracker.side
