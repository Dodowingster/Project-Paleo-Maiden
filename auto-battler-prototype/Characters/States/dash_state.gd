class_name DashState
extends State

@export var time_till_actionable: float = 0.0
@onready var current_time_in_state: float = 0.0
@onready var can_act: bool = true

func enter() -> void:
	owner.can_clash = false
	current_time_in_state = 0.0
	if time_till_actionable > 0:
		can_act = false
	else:
		can_act = true

func update(_delta: float):
	if !can_act:
		current_time_in_state += _delta
		if current_time_in_state >= time_till_actionable:
			can_act = true
