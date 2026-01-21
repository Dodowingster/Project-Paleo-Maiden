extends State
class_name StateBlockstun


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0
var initialDistance : float = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.canClash = false
	initialDistance = owner.distance
	if "blockstun" in animList:
		animPlayer.play("blockstun")


func exit():
	var finalDistance : float = owner.distance
	var knockbackDistance : float = finalDistance - initialDistance
	print("Knockback distance: " + str(knockbackDistance))
	animPlayer.stop()


func update(_delta: float):
	#if lastTick != owner.tickCount:
		#lastTick = owner.tickCount
	var chosenState = ""
	owner.hitstun -= _delta
	#var currentHitStun = owner.hitstun
	if owner.hitstun < 0:
		owner.hitstun = 0
		chosenState = "Idle"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass
