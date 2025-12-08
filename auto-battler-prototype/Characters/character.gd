extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
@export var strategy: GlobalValues.STRATEGY
@export var startFacingRight: bool = true

@onready var distance: float = 0
@onready var tickCount: int = 0

func _ready() -> void:
	%SideTracker.set_facing_direction(startFacingRight)
	GlobalValues.connect("updateDataToChar", _on_tick)

func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity * _delta
	move_and_slide()

func _on_tick(rcvDistance: float, rcvTickCount: int):
	distance = rcvDistance
	tickCount = rcvTickCount
