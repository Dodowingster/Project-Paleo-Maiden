extends ActionableState
class_name StateIdle


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
#var lastTick : int = 0
var animList : PackedStringArray = []
var animName : String

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/idle"


func enter():
	owner.canClash = true
	if animName in animList:
		animPlayer.play(animName)


func exit():
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	super.update(_delta)
	


func physics_update(_delta: float):
	pass
