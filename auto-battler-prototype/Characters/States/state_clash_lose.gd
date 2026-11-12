class_name StateClashLose
extends StunState

var anim_list : PackedStringArray = []
var anim_name : String
var last_tick : int = 0
var initial_distance : float = 0
var sprite_og_coordinates : Vector2 = Vector2.ZERO

@onready var anim_player : AnimationPlayer = %AnimationPlayer

func _ready():
	anim_list = anim_player.get_animation_list()
	sprite_og_coordinates = %Sprite.position
	anim_name = owner.anim_lib_name + "/movebackward"

func enter():
	owner.can_clash = false
	owner.face_opponent()
	owner.hitstun = 0.5
	owner.hit_knockback_x = 1000 * %SideTracker.side * -1
	sprite_og_coordinates = %Sprite.position
	if anim_name in anim_list:
		anim_player.play(anim_name)


func exit():
	%Sprite.position = sprite_og_coordinates
	anim_player.stop()


func update(_delta: float):
	# if hitstop frames finished
	if owner.hitstop_frames <= 0:
		var chosen_state = ""
		owner.hitstun -= _delta
		#var currentHitStun = owner.hitstun
		if owner.hitstun < 0:
			owner.hitstun = 0
			chosen_state = "Idle"

		if chosen_state != "":
			transition.emit(self, chosen_state)


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
			anim_player.speed_scale = 0
		owner.velocity = Vector2.ZERO

	# not in hitstop
	else:
		# just finished hitstop
		if owner.was_in_hitstop:
			owner.velocity = owner.stored_velocity
			owner.was_in_hitstop = false
			impact_just_applied = true
			anim_player.speed_scale = 1
		else:
			impact_just_applied = true

	if owner.hitstop_frames > 0:
		owner.hitstop_frames -= 1
