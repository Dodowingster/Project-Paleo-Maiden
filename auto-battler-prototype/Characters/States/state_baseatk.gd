extends State
class_name StateBaseAtk


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var lastTick : int = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "baseattack" in animList:
		animPlayer.play("baseattack")


func exit():
	animPlayer.stop()


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass
	#if lastTick != owner.tickCount:
		#lastTick = owner.tickCount
		#owner.position.x += owner.speed * %SideTracker.side

#func on_change_state_signal_received(newState: String):
	#if newState == "idle":
		#pass
	#if newState == "idle":
		#print("Change State to Idle")
		#transition.emit(self, "Idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "baseattack":
		transition.emit(self, "Idle")
