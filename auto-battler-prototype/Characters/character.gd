extends CharacterBody2D
class_name Character

signal changeState(newState: String)
#signal broadcastAtkStart()
signal broadcastAtkActiveEnd()
signal broadcastWillAtk(willAtk: bool)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
## Mainly for debugging and identification
@export var characterName : String = "P1"
## Base stat to calculate attack damage from
@export var atk: int = 5   # currently unused
## Base stat to calculate damage taken
@export var def: int = 5   # currently unused
## Determines general move speed (in pixels I think?)
@export var spd: int = 5   
## Minimum stamina roll to add to action goal
@export var minSta: int = 1   
## Maximum stamina roll to add to action goal
@export var maxSta: int = 10   

@export var strategy: GlobalValues.STRATEGY
@export var startFacingRight: bool = true

@onready var distance: float = 0
@onready var tickCount: int = 0

## Determines the maximum distance between characters to trigger their attack logic (for AGGRESSIVE strategy)
@export var distanceThreshold: int = 80
## Modifies base forward movement speed
@export var forwardSpdMult: float = 1.0
## Modifies base backward movement speed
@export var backwardSpdMult: float = 0.5

## Determines number of action goal points needed to perform an attack
@export var actionGoalTotal: int = 300
var currentActionGoal: int = 0
var opponentIsAttacking: bool = false

@onready var hitstun : float = 0
@onready var hitknockbackX : float = 0.000
@onready var hitknockbackY : float = 0.000

## Set opponent character here
@export var opponent : CharacterBody2D

func _ready() -> void:
	%SideTracker.set_facing_direction(startFacingRight)
	GlobalValues.connect("updateDataToChar", _on_tick)
	if opponent != null:
		opponent.connect("broadcastWillAtk", decide_action)
		opponent.connect("broadcastAtkActiveEnd", on_atk_active_end_signal_rcvd)

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
		var rng_roll: int = randi() % (maxSta + 1) + minSta
		currentActionGoal += rng_roll
	
	if currentActionGoal >= actionGoalTotal:
		if distance <= distanceThreshold && %StateMachine.currentState is not StateHitstun:
			broadcastWillAtk.emit(true)
			#changeState.emit("baseAttack")
			#broadcastAtkStart.emit()
			#currentActionGoal = 0
		else:
			broadcastWillAtk.emit(false)
	else:
		#if distance > distanceThreshold && %StateMachine.currentState is not StateHitstun:
			#if !(%StateMachine.currentState is StateMoveFwd):
				#changeState.emit("moveForward")
		#else:
			#if !(%StateMachine.currentState is StateIdle):
				#changeState.emit("idle")
		broadcastWillAtk.emit(false)
	

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
		opponentIsAttacking = false
	
func decide_action(oppWillAtk: bool):
	var decision = ""
	if oppWillAtk:
		opponentIsAttacking = true
		if currentActionGoal >= actionGoalTotal:
			if distance <= distanceThreshold && %StateMachine.currentState is not StateHitstun:
				decision = "baseAttack"
				currentActionGoal = 0
		else:
			if %StateMachine.currentState is not StateHitstun && %StateMachine.currentState is not StateBaseAtk:
				decision = "moveBackward"
	else:
		if currentActionGoal >= actionGoalTotal:
			if %StateMachine.currentState is not StateHitstun:
				if distance <= distanceThreshold:
					decision = "baseAttack"
					currentActionGoal = 0
				else:
					if !(%StateMachine.currentState is StateMoveFwd):
						decision = "moveForward"
				
		else:
			if !opponentIsAttacking:
				if distance > distanceThreshold && %StateMachine.currentState is not StateHitstun:
					if !(%StateMachine.currentState is StateMoveFwd):
						decision = "moveForward"
				else:
					if !(%StateMachine.currentState is StateIdle):
						decision = "idle"
	#if characterName == "P1":
		#print(characterName + " action: " + decision)
		#print("Opponent is Attacking: " + str(opponentIsAttacking))
	if decision != "":
		changeState.emit(decision)
	

func on_atk_active_end_signal_rcvd():
	opponentIsAttacking = false
	#if characterName == "P1":
		#print("Atk signal received: opponentIsAttacking set to false")
	if %StateMachine.currentState is StateMoveBkwd:
		%StateMachine.on_child_transition($StateMachine.currentState, "Idle")
	
func broadcast_atk_active_end():
	broadcastAtkActiveEnd.emit()
	opponentIsAttacking = false
	
