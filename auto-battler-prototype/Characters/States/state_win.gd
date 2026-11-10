class_name StateWin
extends State

var anim_list : PackedStringArray = []
var anim_name : String
var last_tick : int = 0
var initial_distance : float = 0
var sprite_og_coordinates : Vector2 = Vector2.ZERO

@onready var anim_player : AnimationPlayer = %AnimationPlayer


func _ready():
	anim_list = anim_player.get_animation_list()
	sprite_og_coordinates = %Sprite.position
	anim_name = owner.anim_lib_name + "/win"

func enter():
	owner.can_clash = false
	sprite_og_coordinates = %Sprite.position
	initial_distance = owner.distance
	if anim_name in anim_list:
		anim_player.animation_set_next(anim_player.current_animation, anim_name)


func exit():
	%Sprite.position = sprite_og_coordinates
	var final_distance : float = owner.distance
	var knockback_distance : float = final_distance - initial_distance
	print("Knockback distance: " + str(knockback_distance))
	anim_player.stop()


func update(_delta: float):
	#if last_tick != owner.tick_count:
		#last_tick = owner.tick_count

	if owner.hitstop_frames <= 0:
		var chosen_state = ""
		owner.hitstun -= _delta
		#var currentHitStun = owner.hitstun
		if owner.hitstun < 0:
			owner.hitstun = 0
			chosen_state = "Win"

		if chosen_state != "":
			transition.emit(self, chosen_state)


func physics_update(_delta: float):
	pass
	# if hitstop animation started
	# if owner.hitstop_frames > 0:
	# 	# if hitstop animation didn't start before
	# 	if not owner.was_in_hitstop:
	# 		owner.stored_velocity = owner.velocity
	# 		owner.was_in_hitstop = true
	# 		anim_player.speed_scale = 0
	# 	owner.velocity = Vector2.ZERO

	# # not in hitstop animation
	# else:
	# 	# just finished hitstop animation
	# 	if owner.was_in_hitstop:
	# 		owner.velocity = owner.stored_velocity
	# 		owner.was_in_hitstop = false
	# 		anim_player.speed_scale = 1
	# if owner.hitstop_frames > 0:
	# 	#shake_sprite(owner.hitstop_frames, 2)
	# 	owner.hitstop_frames -= 1

#func shake_sprite(currentHitStopFrame: int, pixelShake: int):
	#if currentHitStopFrame % 3 == 0:
		#%Sprite.position.x = sprite_og_coordinates.x + pixelShake
	#elif currentHitStopFrame % 2 == 0:
		#%Sprite.position.x = sprite_og_coordinates.x
	#elif currentHitStopFrame % 1 == 0:
		#%Sprite.position.x = sprite_og_coordinates.x - pixelShake
	#else:
		#%Sprite.position.x = sprite_og_coordinates.x
