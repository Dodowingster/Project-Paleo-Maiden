class_name StateIdle
extends ActionableState

#var last_tick : int = 0
var anim_list : PackedStringArray = []
var anim_name : String

@onready var anim_player : AnimationPlayer = %AnimationPlayer

func _ready():
	anim_list = anim_player.get_animation_list()
	anim_name = owner.anim_lib_name + "/idle"


func enter():
	super.enter()
	if anim_name in anim_list:
		anim_player.play(anim_name)


func exit():
	anim_player.play(owner.anim_lib_name + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	pass
