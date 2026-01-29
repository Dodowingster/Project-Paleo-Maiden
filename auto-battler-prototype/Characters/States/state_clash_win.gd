extends State
class_name StateClashWin


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animName : String

func _ready():
	animList = animPlayer.get_animation_list()
	animName = owner.animLibName + "/clashwin"

func enter():
	owner.canClash = false
	if animName in animList:
		animPlayer.play(animName)


func exit():
	animPlayer.stop()


func update(_delta: float):
	pass
	#currentDuration += _delta
	#if currentDuration >= animDuration:
		#transition.emit(self, "Idle")


func physics_update(_delta: float):
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animName:
		transition.emit(self, "Idle")
