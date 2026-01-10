extends State
class_name StateHitstun


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String
var lastTick : int = 0
var initialDistance : float = 0
var spriteOGCoordinates : Vector2 = Vector2.ZERO

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/hitstun"
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
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	#if lastTick != owner.tickCount:
		#lastTick = owner.tickCount
	
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
	# if hitstop already started
	if owner.hitstop_frames > 0:
		# if hitstop didn't start before
		if not owner.was_in_hitstop:
			owner.stored_velocity = owner.velocity
			owner.was_in_hitstop = true
			animPlayer.speed_scale = 0
		owner.velocity = Vector2.ZERO

	# not in hitstop
	else:
		# just finished hitstop
		if owner.was_in_hitstop:
			owner.velocity = owner.stored_velocity
			owner.was_in_hitstop = false
			animPlayer.speed_scale = 1
	
	if owner.hitstop_frames > 0:
		shake_sprite(owner.hitstop_frames, 2)
		owner.hitstop_frames -= 1

func shake_sprite(currentHitStopFrame: int, pixelShake: int):
	if currentHitStopFrame % 3 == 0:
		%Sprite.position.x = spriteOGCoordinates.x + pixelShake
	elif currentHitStopFrame % 2 == 0:
		%Sprite.position.x = spriteOGCoordinates.x
	elif currentHitStopFrame % 1 == 0:
		%Sprite.position.x = spriteOGCoordinates.x - pixelShake
	else:
		%Sprite.position.x = spriteOGCoordinates.x
