extends StunState
class_name StateBlockstun


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String
var lastTick : int = 0
var initialDistance : float = 0

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/blockstun"

func enter():
	owner.canClash = false
	owner.face_opponent()
	initialDistance = owner.distance
	if animName in animList:
		animPlayer.play(animName)


func exit():
	var finalDistance : float = owner.distance
	var knockbackDistance : float = finalDistance - initialDistance
	print("Block knockback distance: " + str(knockbackDistance))
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	# if hitstop frames finished
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
	if impact_just_applied:
		impact_just_applied = false
	# if hitstop already started
	if owner.hitstop_frames > 0:
		# if hitstop didn't start before
		if not owner.was_in_hitstop:
			owner.stored_velocity = owner.velocity
			owner.was_in_hitstop = true
			impact_just_applied = false
			animPlayer.speed_scale = 0
		owner.velocity = Vector2.ZERO

	# not in hitstop
	else:
		# just finished hitstop
		if owner.was_in_hitstop:
			owner.velocity = owner.stored_velocity
			owner.was_in_hitstop = false
			impact_just_applied = true
			animPlayer.speed_scale = 1
		else:
			impact_just_applied = true
	
	if owner.hitstop_frames > 0:
		owner.hitstop_frames -= 1
