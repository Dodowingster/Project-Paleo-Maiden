class_name StateBaseAtk
extends State

var anim_list : PackedStringArray = []
var anim_name : String
var last_tick : int = 0

@onready var anim_player : AnimationPlayer = %AnimationPlayer

#var spriteOGCoordinates : Vector2 = Vector2.ZERO

func _ready():
	anim_list = anim_player.get_animation_list()
	anim_name = owner.anim_lib_name + "/baseattack"

func enter():
	owner.can_clash = false
	owner.current_action_stock -= 1
	owner.opponent.opponent_is_attacking = true
	if anim_name in anim_list:
		anim_player.play(anim_name)


func exit():
	anim_player.play(owner.anim_lib_name + "/RESET")


func update(_delta: float):
	pass


func physics_update(_delta: float):
	if owner.hitstop_frames > 0:
		if not owner.was_in_hitstop:
			owner.stored_velocity = owner.velocity
			owner.was_in_hitstop = true
			anim_player.speed_scale = 0
		owner.velocity = Vector2.ZERO
	else:
		if owner.was_in_hitstop:
			owner.velocity = owner.stored_velocity
			owner.was_in_hitstop = false
			anim_player.speed_scale = 1
	if owner.hitstop_frames > 0:
		owner.hitstop_frames -= 1

func _on_animation_player_animation_finished(animation_name: StringName) -> void:
	if animation_name == anim_name:
		transition.emit(self, "Idle")
