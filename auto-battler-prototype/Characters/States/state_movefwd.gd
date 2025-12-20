extends ActionableState
class_name StateMoveFwd


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "moveforward" in animList:
		animPlayer.play("moveforward")


func exit():
	animPlayer.stop()


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	if lastTick != owner.tickCount:
		lastTick = owner.tickCount
		owner.position.x += owner.spd * owner.forwardSpdMult * %SideTracker.side
