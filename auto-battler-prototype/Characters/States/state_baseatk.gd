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
	pass


func physics_update(_delta: float):
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "baseattack":
		transition.emit(self, "Idle")
