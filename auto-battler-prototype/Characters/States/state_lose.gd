extends StunState
class_name StateLose


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String
var lastTick : int = 0
var initialDistance : float = 0
var spriteOGCoordinates : Vector2 = Vector2.ZERO
@export var timer : float = 1.0

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/lose"
	spriteOGCoordinates = %Sprite.position

func enter():
	owner.canClash = false
	spriteOGCoordinates = %Sprite.position
	initialDistance = owner.distance
	if animName in animList:
		animPlayer.play(animName)


func exit():
	%Sprite.position = spriteOGCoordinates
	var finalDistance : float = owner.distance
	var knockbackDistance : float = finalDistance - initialDistance
	print("Knockback distance: " + str(knockbackDistance))
	animPlayer.stop()


func update(_delta: float):
	timer -= _delta

	if timer <= 0.0:
		owner.broadcastLose.emit()

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
	pass
