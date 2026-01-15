extends State
class_name StateClashing


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animDuration : float = 1.0
var currentDuration : float = 0.0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	currentDuration = 0.0
	if "blockstun" in animList:
		animPlayer.play("blockstun")


func exit():
	animPlayer.stop()


func update(_delta: float):
	currentDuration += _delta
	if currentDuration >= animDuration:
		transition.emit(self, "Idle")


func physics_update(_delta: float):
	pass
