extends CharacterBody2D
class_name Character

#signal changeState(newState: String)
#signal broadcastAtkStart()
signal broadcastAtkActiveEnd()
signal broadcastAction(action : GlobalValues.ACTION)
signal broadcastClashResult(result : bool)
signal broadcastWinState()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
## Mainly for debugging and identification
@export var characterName : String = "P1"
@export var animLibName : String
## Base stat to calculate attack damage from
@export var atk: int = 5   # currently unused
## Base stat to calculate damage taken
@export var def: int = 5   # currently unused
## Determines general move speed (in pixels I think?)
@export var spd: int = 10   
## Minimum stamina roll to add to action goal
@export var minSta: int = 1   
## Maximum stamina roll to add to action goal
@export var maxSta: int = 10   
## Maximum HP
@export var maxHP: int = 100

@export var strategy: GlobalValues.STRATEGY
@export var startFacingRight: bool = true

@onready var distance: float = 0
@onready var tickCount: int = 0

## Determines the maximum distance between characters to trigger their attack logic (for AGGRESSIVE strategy)
@export var minDistance: int = 80
@export var maxDistance: int = 100
## Modifies base forward movement speed
@export var forwardSpdMult: float = 1.0
## Modifies base backward movement speed
@export var backwardSpdMult: float = 0.5

## Determines number of action goal points needed to perform an attack
@export var actionGoalTotal: int = 300
var currentActionGoal: int = 0
var opponentIsAttacking: bool = false
var canClash = false
var wantToClash = false
var clashResult : bool = false
var oppClashResult : bool = false

@onready var hitstun : float = 0
@onready var hitknockbackX : float = 0.000
@onready var hitknockbackY : float = 0.000
@onready var health : int = maxHP

## Set opponent character here
@export var opponent : Character

var hitstop_frames: int = 0
var stored_velocity: Vector2 = Vector2.ZERO
var was_in_hitstop: bool = false

func _ready() -> void:
	%SideTracker.set_facing_direction(startFacingRight)
	GlobalValues.connect("updateDataToChar", _on_tick)
	if opponent != null:
		opponent.connect("broadcastAction", decide_action)
		opponent.connect("broadcastAtkActiveEnd", on_atk_active_end_signal_rcvd)
		opponent.connect("broadcastClashResult", on_clash_result_rcvd)
		opponent.connect("broadcastWinState", on_win_confirmed)

func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity
	if hitknockbackX != 0:
		velocity.x = hitknockbackX
		hitknockbackX = 0.000
		hitknockbackY = 0.000
	else:
		velocity.x = lerp(velocity.x, 0.000, 0.250)


func check_can_attack():
	return (currentActionGoal >= actionGoalTotal && 			# Action goal check
			distance <= minDistance && 							# Distance check (attack close enough to hit)
			%StateMachine.currentState is not StateHitstun)		# Histun check

func check_want_to_attack():
	return (currentActionGoal >= actionGoalTotal && 			# Action goal check
			%StateMachine.currentState is not StateHitstun)		# Hitstun check

func min_distance_hit():
	return distance <= minDistance

func clash_check():
	var win_clash_chance = (float(atk + def) / float(atk + def + opponent.atk + opponent.def)) * 100
	var win_clash_check = randi() % 100
	return win_clash_check <= win_clash_chance

func determine_clash_winner():
	clashResult = clash_check()
	broadcastClashResult.emit(clashResult)
	
func on_clash_result_rcvd(result: bool):
	oppClashResult = result
	print(opponent.characterName + " Clash Result: " + str(oppClashResult))

# What the character does each tick
func _on_tick(rcvDistance: float, rcvTickCount: int):
	distance = rcvDistance
	tickCount = rcvTickCount
	wantToClash = false
	if %StateMachine.currentState is not StateHitstun \
	and %StateMachine.currentState is not StateClashing \
	and %StateMachine.currentState is not StateClashLose:
		#currentActionGoal += sta
		var rng_roll: int = randi() % (maxSta + 1) + minSta
		currentActionGoal += rng_roll
	
	if strategy == GlobalValues.STRATEGY.AGGRESSIVE:
		if check_can_attack():
			broadcastAction.emit(GlobalValues.ACTION.ATTACK)
		else:
			broadcastAction.emit(GlobalValues.ACTION.MOVE)
	elif strategy == GlobalValues.STRATEGY.BALANCED:
		if check_want_to_attack() and distance > minDistance and distance < maxDistance:
			broadcastAction.emit(GlobalValues.ACTION.ATTACK)
		else:
			broadcastAction.emit(GlobalValues.ACTION.MOVE)
	else:
		if check_can_attack():
			broadcastAction.emit(GlobalValues.ACTION.ATTACK)
		else:
			broadcastAction.emit(GlobalValues.ACTION.MOVE)


func get_hit(hitbox: HitBox, _hurtbox: Hurtbox):
	var parent = hitbox.owner
	if parent != self:
		print("Attack detected, parent = " + parent.characterName + " dmg = " + str(hitbox.damage) + ", groupname = " + hitbox.groupName)
		var chosenHitState = "Hitstun"
		
		# Check character currently moving backwards, char blocks
		if %StateMachine.currentState is StateMoveBkwd or %StateMachine.currentState is StateBlockstun:
			chosenHitState = "Blockstun"
			hitstun = hitbox.blockstun
			hitknockbackX = hitbox.blockbackX * %SideTracker.side * -1
			hitknockbackY = hitbox.blockbackY

			# Check for KO (no chip kill)
			if health - floor(hitbox.damage * 0.3) < 0:
				health = 1
			else:
				health -= floor(hitbox.damage * 0.3)
		
		# Else character got hit
		else:
			hitstop_frames = max(hitstop_frames, hitbox.hitstopFrames)
			hitbox.owner.hitstop_frames = max(hitbox.owner.hitstop_frames, hitbox.hitstopFrames)
			hitstun = hitbox.hitstun
			hitknockbackX = hitbox.knockbackX * %SideTracker.side * -1
			hitknockbackY = hitbox.knockbackY

			# Check for KO
			if health - hitbox.damage <= 0:
				chosenHitState = "Lose"
				health = 0
				broadcastWinState.emit()
			else:
				health -= hitbox.damage
		#
		#Hitvfx.showHit.emit(hitbox, hurtbox)
		#
		
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


func decide_action(oppAction: GlobalValues.ACTION):
	if oppAction == GlobalValues.ACTION.ATTACK:
		opponentIsAttacking = true
		
	

func on_atk_active_end_signal_rcvd():
	opponentIsAttacking = false
	
func broadcast_atk_active_end():
	broadcastAtkActiveEnd.emit()
	opponentIsAttacking = false

func on_win_confirmed():
	# stop doing stuff
	var chosenHitState = "Win"
	%StateMachine.on_child_transition($StateMachine.currentState, chosenHitState)
