extends CharacterBody2D

signal changeState(newState: String)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

@export var atk: int = 5
@export var def: int = 5
@export var spd: int = 5
@export var sta: int = 10
@export var rngRollMin: int = 1
@export var rngRollMax: int = 10

@export var strategy: GlobalValues.STRATEGY
@export var startFacingRight: bool = true

@onready var distance: float = 0
@onready var tickCount: int = 0

@export var distanceThreshold: int = 80
@export var speed: float = 3.0

@export var actionGoalTotal: int = 300
var currentActionGoal: int = 0

func _ready() -> void:
	%SideTracker.set_facing_direction(startFacingRight)
	GlobalValues.connect("updateDataToChar", _on_tick)

func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity * _delta

func _on_tick(rcvDistance: float, rcvTickCount: int):
	distance = rcvDistance
	tickCount = rcvTickCount
	#currentActionGoal += sta
	var rng_roll: int = randi() % (rngRollMax + 1) + rngRollMin
	currentActionGoal += rng_roll
	
	if currentActionGoal >= actionGoalTotal:
		changeState.emit("baseAttack")
		currentActionGoal = 0
	else:
		if distance > distanceThreshold:
			if !(%StateMachine.currentState is StateMoveFwd):
				changeState.emit("moveForward")
		else:
			if !(%StateMachine.currentState is StateIdle):
				changeState.emit("idle")
	
