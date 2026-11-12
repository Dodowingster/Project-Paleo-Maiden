class_name StateClashing
extends State

var anim_list : PackedStringArray = []
var anim_duration : float = 0.5
var current_duration : float = 0.0
var clash_anims: PackedStringArray = ["blockstun", "clash2"]
var clash_vfx : Node2D
var clash_result_obtained : bool = false

@onready var anim_player : AnimationPlayer = %AnimationPlayer


func _ready():
	anim_list = anim_player.get_animation_list()

func enter():
	owner.can_clash = true
	owner.face_opponent()
	current_duration = 0.0
	owner.velocity.x = 0
	var anim_index = randi_range(0, clash_anims.size() - 1)
	if (owner.anim_lib_name + "/" + clash_anims[anim_index]) in anim_list:
		anim_player.play(owner.anim_lib_name + "/" + clash_anims[anim_index])
	clash_vfx = VFXManager.spawn_clash_vfx(owner, owner.opponent)
	clash_result_obtained = false


func exit():
	clash_result_obtained = false
	owner.clash_result = false
	owner.opp_clash_result = false
	if clash_vfx != null:
		VFXManager.despawn_clash_vfx(clash_vfx)
		clash_vfx = null
	anim_player.stop()


func update(_delta: float):
	if !clash_result_obtained:
		owner.determine_clash_winner()
		clash_result_obtained = true
	current_duration += _delta
	if current_duration >= anim_duration:
		if owner.clash_result == owner.opp_clash_result or !owner.clash_result:
			transition.emit(self, "ClashLose")
		else:
			transition.emit(self, "ClashWin")


func physics_update(_delta: float):
	pass
