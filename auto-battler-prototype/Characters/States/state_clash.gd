extends State
class_name StateClashing


@onready var animPlayer : AnimationPlayer = %AnimationPlayer
var animList : PackedStringArray = []
var animDuration : float = 1.0
var currentDuration : float = 0.0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	currentDuration = 0.0
	if "blockstun" in animList:
		animPlayer.play("blockstun")
	owner.determine_clash_winner()


func exit():
	owner.clashResult = false
	owner.oppClashResult = false
	animPlayer.stop()


func update(_delta: float):
	currentDuration += _delta
	if currentDuration >= animDuration:
		print(owner.characterName + " Clash Result: " + str(owner.clashResult))
		print(owner.opponent.characterName + " Clash Result: " + str(owner.opponent.clashResult))
		print("")
		if owner.clashResult:
			if owner.oppClashResult:
				transition.emit(self, "Idle")
			else:
				transition.emit(self, "ClashWin")
		else:
			if !owner.oppClashResult:
				transition.emit(self, "Idle")
			else:
				owner.hitstun = 0.6
				owner.hitknockbackX = 600 * %SideTracker.side * -1
				transition.emit(self, "Hitstun")
					


func physics_update(_delta: float):
	pass
