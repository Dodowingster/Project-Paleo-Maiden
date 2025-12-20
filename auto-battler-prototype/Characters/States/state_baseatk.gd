extends State
class_name StateBaseAtk


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.currentActionGoal = 0
	if "baseattack" in animList:
		animPlayer.play("baseattack")


func exit():
	animPlayer.stop()


func update(_delta: float):
	if owner.hitstop_frames > 0:
		owner.hitstop_frames -= 1


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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "baseattack":
		transition.emit(self, "Idle")
