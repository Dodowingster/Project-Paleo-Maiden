class_name StateMoveBkwd
extends ActionableState

var anim_list : PackedStringArray = []
var anim_name : String

@onready var anim_player : AnimationPlayer = %AnimationPlayer

func _ready():
	anim_list = anim_player.get_animation_list()
	anim_name = owner.anim_lib_name + "/movebackward"


func enter():
	super.enter()
	if anim_name in anim_list:
		anim_player.play(anim_name)


func exit():
	anim_player.play(owner.anim_lib_name + "/RESET")


func update(_delta: float):
	super.update(_delta)


func physics_update(_delta: float):
	owner.velocity.x = -(owner.spd * owner.backward_spd_mult * %SideTracker.side)
