extends State
class_name StateHitstun


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0
var initialDistance : float = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	initialDistance = owner.distance
	if "hitstun" in animList:
		animPlayer.play("hitstun")


func exit():
	var finalDistance : float = owner.distance
	var knockbackDistance : float = finalDistance - initialDistance
	print("Knockback distance: " + str(knockbackDistance))
	animPlayer.stop()


func update(_delta: float):
	#if lastTick != owner.tickCount:
		#lastTick = owner.tickCount
	if owner.hitstop_frames <= 0:
		var chosenState = ""
		owner.hitstun -= _delta
		#var currentHitStun = owner.hitstun
		if owner.hitstun < 0:
			owner.hitstun = 0
			chosenState = "Idle"
		
		if chosenState != "":
			transition.emit(self, chosenState)


func physics_update(_delta: float):
	if owner.hitstop_frames > 0:
		if not owner.was_in_hitstop:
			owner.stored_velocity = owner.velocity
			owner.was_in_hitstop = true
			animPlayer.speed_scale = 0
		owner.velocity = Vector2.ZERO
	else:
		if owner.was_in_hitstop:
			owner.velocity = owner.stored_velocity
			owner.was_in_hitstop = false
			animPlayer.speed_scale = 1
	if owner.hitstop_frames > 0:
		owner.hitstop_frames -= 1
