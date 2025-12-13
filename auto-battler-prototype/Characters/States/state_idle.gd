extends State
class_name StateIdle


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()
	owner.connect("changeState", on_change_state_signal_received)


func enter():
	if "idle" in animList:
		animPlayer.play("idle")


func exit():
	animPlayer.stop()


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass

func on_change_state_signal_received(newState: String):
	if newState == "moveForward":
		transition.emit(self, "MoveForward")
	elif newState == "moveBackward":
		transition.emit(self, "MoveBackward")
	elif newState == "baseAttack":
		transition.emit(self, "BaseAttack")
