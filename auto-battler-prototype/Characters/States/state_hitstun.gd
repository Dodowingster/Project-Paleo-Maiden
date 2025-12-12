extends State
class_name StateHitstun


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "hitstun" in animList:
		animPlayer.play("hitstun")


func exit():
	animPlayer.stop()


func update(_delta: float):
	var chosenState = ""
	owner.hitstun -= _delta
	if owner.hitstun < 0:
		owner.hitstun = 0
		chosenState = "Idle"
	
	transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass
	#if lastTick != owner.tickCount:
		#lastTick = owner.tickCount
		#owner.position.x += owner.speed * %SideTracker.side

#func on_change_state_signal_received(newState: String):
	#if newState == "idle":
		#pass
	#if newState == "idle":
		#print("Change State to Idle")
		#transition.emit(self, "Idle")
