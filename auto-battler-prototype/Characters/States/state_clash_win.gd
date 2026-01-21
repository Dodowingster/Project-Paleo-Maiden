extends State
class_name StateClashWin


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.canClash = false
	if "clashwin" in animList:
		animPlayer.play("clashwin")


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
	if anim_name == "clashwin":
		transition.emit(self, "Idle")
