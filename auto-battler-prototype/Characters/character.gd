extends CharacterBody2D

signal changeState(newState: String)
signal broadcastAtk()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
@export var characterName : String = "P1"
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

@onready var hitstun : float = 0
@onready var hitknockbackX : float = 0.000
@onready var hitknockbackY : float = 0.000

@export var opponent : CharacterBody2D

func _ready() -> void:
	%SideTracker.set_facing_direction(startFacingRight)
	GlobalValues.connect("updateDataToChar", _on_tick)
	if opponent != null:
		opponent.connect("broadcastAtk", on_atk_signal_rcvd)

func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity
	if hitknockbackX != 0:
		velocity.x = hitknockbackX
		hitknockbackX = 0.000
		hitknockbackY = 0.000
	else:
		velocity.x = lerp(velocity.x, 0.000, 0.250)

func _on_tick(rcvDistance: float, rcvTickCount: int):
	distance = rcvDistance
	tickCount = rcvTickCount
	if %StateMachine.currentState is not StateHitstun:
		#currentActionGoal += sta
		var rng_roll: int = randi() % (rngRollMax + 1) + rngRollMin
		currentActionGoal += rng_roll
	
	if currentActionGoal >= actionGoalTotal:
		if distance <= distanceThreshold && %StateMachine.currentState is not StateHitstun:
			changeState.emit("baseAttack")
			broadcastAtk.emit()
			currentActionGoal = 0
	else:
		if distance > distanceThreshold && %StateMachine.currentState is not StateHitstun:
			if !(%StateMachine.currentState is StateMoveFwd):
				changeState.emit("moveForward")
		else:
			if !(%StateMachine.currentState is StateIdle):
				changeState.emit("idle")

func get_hit(hitbox: HitBox, _hurtbox: Hurtbox):
	var parent = hitbox.owner
	if parent != self:
		print("Attack detected, parent = " + parent.characterName + " dmg = " + str(hitbox.damage) + ", groupname = " + hitbox.groupName)
		
		hitstun = hitbox.hitstun
		hitknockbackX = hitbox.knockbackX * %SideTracker.side * -1
		hitknockbackY = hitbox.knockbackY
		#
		#Hitvfx.showHit.emit(hitbox, hurtbox)
		#
		var chosenHitState = "Hitstun"
		#if abs(hitknockbackX) < abs(hitknockbackY)/2:
			#tumble = true
			#if hitknockbackY < 0:
				#chosenHitState = "EnemyHitUp"
			#elif hitknockbackY > 0:
				#chosenHitState = "EnemyHitDown"
		#elif abs(hitknockbackX) > abs(hitknockbackY)/2:
			#tumble = true
			#chosenHitState = "EnemyHitAway"
			#if hitknockbackX > 0:
				#flip_char("left")
			#elif hitknockbackX < 0:
				#flip_char("right")
		#
		%StateMachine.on_child_transition($StateMachine.currentState, chosenHitState)
	
func on_atk_signal_rcvd():
	pass
	#if %StateMachine.currentState is not StateHitstun && %StateMachine.currentState is not StateBaseAtk:
		#changeState.emit("moveBackward")
	
