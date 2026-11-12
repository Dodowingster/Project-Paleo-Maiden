class_name StateBlockstun
extends StunState

var anim_list : PackedStringArray = []
var anim_name : String
var last_tick : int = 0
var initial_distance : float = 0

@onready var anim_player : AnimationPlayer = %AnimationPlayer


func _ready():
	anim_list = anim_player.get_animation_list()
	anim_name = owner.anim_lib_name + "/blockstun"

func enter():
	owner.can_clash = false
	owner.current_action_stock -= 1
	owner.face_opponent()
	initial_distance = owner.distance
	if anim_name in anim_list:
		anim_player.play(anim_name)


func exit():
	var final_distance : float = owner.distance
	var knockback_distance : float = final_distance - initial_distance
	print("Block knockback distance: " + str(knockback_distance))
	anim_player.play(owner.anim_lib_name + "/RESET")


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
