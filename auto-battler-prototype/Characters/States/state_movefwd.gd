extends State
class_name StateMoveFwd


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0

func _ready():
	animList = animPlayer.get_animation_list()
	owner.connect("changeState", on_change_state_signal_received)

func enter():
	if "moveforward" in animList:
		animPlayer.play("moveforward")


func exit():
	animPlayer.stop()


func update(_delta: float):
	pass


func physics_update(_delta: float):
	if lastTick != owner.tickCount:
		lastTick = owner.tickCount
		owner.position.x += owner.spd * owner.forwardSpdMult * %SideTracker.side

func on_change_state_signal_received(newState: String):
	if newState == "idle":
		transition.emit(self, "Idle")
	elif newState == "moveBackward":
		transition.emit(self, "MoveBackward")
	elif newState == "baseAttack":
		transition.emit(self, "BaseAttack")
