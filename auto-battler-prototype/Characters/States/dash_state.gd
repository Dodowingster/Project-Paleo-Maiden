extends State
class_name DashState

@export var timeTillActionable: float = 0.0
@onready var currentTimeInState: float = 0.0
@onready var canAct: bool = true

func enter() -> void:
	owner.canClash = false
	currentTimeInState = 0.0
	if timeTillActionable > 0:
		canAct = false
	else:
		canAct = true

func update(_delta: float):
	if !canAct:
		currentTimeInState += _delta
		if currentTimeInState >= timeTillActionable:
			canAct = true
