extends State
class_name StateClashing


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animDuration : float = 0.5
var currentDuration : float = 0.0
var clash_anims: PackedStringArray = ["blockstun", "clash2"]

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.canClash = true
	currentDuration = 0.0
	var animIndex = randi_range(0, clash_anims.size() - 1)
	if (owner.animLibName + "/" + clash_anims[animIndex]) in animList:
		animPlayer.play(owner.animLibName + "/" + clash_anims[animIndex])
	owner.determine_clash_winner()


func exit():
	owner.clashResult = false
	owner.oppClashResult = false
	animPlayer.stop()


func update(_delta: float):
	currentDuration += _delta
	if currentDuration >= animDuration:
		if owner.clashResult == owner.oppClashResult or !owner.clashResult:
			owner.hitstun = 0.5
			owner.hitknockbackX = 1000 * %SideTracker.side * -1
			transition.emit(self, "ClashLose")
		else:
			transition.emit(self, "ClashWin")
					


func physics_update(_delta: float):
	pass
