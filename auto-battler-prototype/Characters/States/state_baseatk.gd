extends State
class_name StateBaseAtk


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String
var lastTick : int = 0
#var spriteOGCoordinates : Vector2 = Vector2.ZERO

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/baseattack"

func enter():
	owner.canClash = false
	owner.currentActionGoal = 0
	if animName in animList:
		animPlayer.play(animName)


func exit():
	animPlayer.play(owner.animLibName + "/RESET")


func update(_delta: float):
	pass


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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animName:
		transition.emit(self, "Idle")
