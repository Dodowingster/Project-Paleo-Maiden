extends State
class_name StateClashing


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animDuration : float = 0.5
var currentDuration : float = 0.0
var clash_anims: PackedStringArray = ["blockstun", "clash2"]
var clash_vfx : Node2D
var clash_result_obtained : bool = false

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.canClash = true
	owner.face_opponent()
	currentDuration = 0.0
	owner.velocity.x = 0
	var animIndex = randi_range(0, clash_anims.size() - 1)
	if (owner.animLibName + "/" + clash_anims[animIndex]) in animList:
		animPlayer.play(owner.animLibName + "/" + clash_anims[animIndex])
	clash_vfx = VFXManager.spawn_clash_vfx(owner, owner.opponent)
	clash_result_obtained = false


func exit():
	clash_result_obtained = false
	owner.clashResult = false
	owner.oppClashResult = false
	if clash_vfx != null:
		VFXManager.despawn_clash_vfx(clash_vfx)
		clash_vfx = null
	animPlayer.stop()


func update(_delta: float):
	if !clash_result_obtained:
		owner.determine_clash_winner()
		clash_result_obtained = true
	currentDuration += _delta
	if currentDuration >= animDuration:
		if owner.clashResult == owner.oppClashResult or !owner.clashResult:
			transition.emit(self, "ClashLose")
		else:
			transition.emit(self, "ClashWin")
					


func physics_update(_delta: float):
	pass
