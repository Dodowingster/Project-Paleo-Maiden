extends ActionableState
class_name StateIdle


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
#var lastTick : int = 0
var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "idle" in animList:
		animPlayer.play("idle")


func exit():
	animPlayer.stop()


func update(_delta: float):
	super.update(_delta)
	


func physics_update(_delta: float):
	pass
