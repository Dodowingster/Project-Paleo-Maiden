extends Node
class_name StateClashLose


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "clashwin" in animList:
		animPlayer.play("clashwin")


func exit():
	animPlayer.stop()


func update(_delta: float):
	pass
	#currentDuration += _delta
	#if currentDuration >= animDuration:
		#transition.emit(self, "Idle")


func physics_update(_delta: float):
	pass
