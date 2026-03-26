extends CharacterBody2D
class_name Character

#signal changeState(newState: String)
#signal broadcastAtkStart()
signal broadcastAtkActiveEnd()
signal broadcastAction(action : GlobalValues.ACTION)
signal broadcastClashResult(result : bool)
signal broadcastWinState()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var characterData : CharacterData
## Mainly for debugging and identification
@onready var characterName : String
@onready var animLibName : String
## Base stat to calculate attack damage from
@onready var atk: int  # currently unused
## Base stat to calculate damage taken
@onready var def: int  # currently unused
## Determines general move speed (in pixels I think?)
@onready var spd: int   
## Minimum stamina roll to add to action goal
@onready var minSta: int  
## Maximum stamina roll to add to action goal
@onready var maxSta: int   
## Maximum HP
@onready var maxHP: int

@onready var strategy: GlobalValues.STRATEGY
@export var startFacingRight: bool = true

@onready var distance: float
@onready var tickCount: int

## Determines the maximum distance between characters to trigger their attack logic (for AGGRESSIVE strategy)
@onready var minDistance: int
@onready var maxDistance: int
## Modifies base forward movement speed
@onready var forwardSpdMult: float
## Modifies base backward movement speed
@onready var backwardSpdMult: float

## Determines number of action goal points needed to perform an attack
@onready var actionGoalTotal: int
var currentActionGoal: int = 0
var opponentIsAttacking: bool = false
var canClash = false
var wantToClash = false
var clashResult : bool = false
var oppClashResult : bool = false

var hitstun : float = 0
var hitknockbackX : float = 0.000
var hitknockbackY : float = 0.000
var health : int = maxHP
var loadout : Loadout

## Set opponent character here
@export var opponent : Character

var hitstop_frames: int = 0
var stored_velocity: Vector2 = Vector2.ZERO
var was_in_hitstop: bool = false

var velocity_x_before_wall : float = 0

func _enter_tree() -> void:
	loadout = %Loadout
	characterName = characterData.characterName
	animLibName = characterData.animLibName
	# clear animation libraries
	var libs : Array[StringName] = %AnimationPlayer.get_animation_library_list()
	for lib in libs:
		%AnimationPlayer.remove_animation_library(lib)
	# add the needed animation library
	%AnimationPlayer.add_animation_library(animLibName, characterData.animLib)
	atk = characterData.atk
	def = characterData.def
	spd = characterData.spd
	minSta = characterData.minSta
	maxSta = characterData.maxSta
	maxHP = characterData.maxHP
	strategy = characterData.strategy
	minDistance = characterData.minDistance
	maxDistance = characterData.maxDistance
	forwardSpdMult = characterData.forwardSpdMult
	backwardSpdMult = characterData.backwardSpdMult
	actionGoalTotal = characterData.actionGoalTotal
	
	health = maxHP

func _ready() -> void:
	%SideTracker.set_facing_direction(startFacingRight)
	
	#base atk stuff
	%BaseAtkHitbox.damage = characterData.baseAtkData.damage
	%BaseAtkHitbox.hitstun = characterData.baseAtkData.hitstun
	%BaseAtkHitbox.blockstun = characterData.baseAtkData.blockstun
	%BaseAtkHitbox.knockbackX = characterData.baseAtkData.knockbackX
	%BaseAtkHitbox.knockbackY = characterData.baseAtkData.knockbackY
	%BaseAtkHitbox.blockbackX = characterData.baseAtkData.blockbackX
	%BaseAtkHitbox.blockbackY = characterData.baseAtkData.blockbackY
	%BaseAtkHitbox.hitstopFrames = characterData.baseAtkData.hitstopFrames
	%BaseAtkHitbox.isMultiHit = characterData.baseAtkData.isMultiHit
	%BaseAtkHitbox.groupName = characterData.baseAtkData.groupName
	# set hitbox shape (eventually need to initialize collisionshapes in here)
	var hitboxshape : CollisionShape2D = %BaseAtkHitbox.get_child(0)
	hitboxshape.shape = characterData.baseAtkData.hitboxShape
	
	GlobalValues.connect("updateDataToChar", _on_tick)
	if opponent != null:
		opponent.connect("broadcastAction", decide_action)
		opponent.connect("broadcastAtkActiveEnd", on_atk_active_end_signal_rcvd)
		opponent.connect("broadcastClashResult", on_clash_result_rcvd)
		opponent.connect("broadcastWinState", on_win_confirmed)
		distance = abs(opponent.position.x - position.x)

func setup_loadout(techniqueDataList : Array[TechniqueData]) -> void:
	var resetAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/RESET")
	var hitstunAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/hitstun")
	for technique_data in techniqueDataList:
		var techniqueNode = technique_data.technique.instantiate()
		if techniqueNode is Technique:
			loadout.add_child(techniqueNode)
			for i in technique_data.hitboxes.size():
				var techniqueHitbox : HitBox = HitBox.new()
				techniqueHitbox.damage = technique_data.hitboxes[i].damage
				techniqueHitbox.hitstun = technique_data.hitboxes[i].hitstun
				techniqueHitbox.blockstun = technique_data.hitboxes[i].blockstun
				techniqueHitbox.knockbackX = technique_data.hitboxes[i].knockbackX
				techniqueHitbox.knockbackY = technique_data.hitboxes[i].knockbackY
				techniqueHitbox.blockbackX = technique_data.hitboxes[i].blockbackX
				techniqueHitbox.blockbackY = technique_data.hitboxes[i].blockbackY
				techniqueHitbox.hitstopFrames = technique_data.hitboxes[i].hitstopFrames
				techniqueHitbox.isMultiHit = technique_data.hitboxes[i].isMultiHit
				techniqueHitbox.groupName = technique_data.hitboxes[i].groupName
				var hitboxShape : CollisionShape2D = CollisionShape2D.new()
				hitboxShape.shape = technique_data.hitboxes[i].hitboxShape
				hitboxShape.disabled = true
				hitboxShape.visible = false
				hitboxShape.debug_color = Color(0.69, 0, 0, 0.41)
				hitboxShape.position = technique_data.hitboxes[i].location
				techniqueHitbox.add_child(hitboxShape)
				%SideTracker.add_child(techniqueHitbox)
				techniqueHitbox.owner = self
				# set keys for technique
				var techniqueAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/" + techniqueNode.animName)
				var track_idx = techniqueAnim.add_track(Animation.TYPE_VALUE)
				techniqueAnim.track_set_path(track_idx, "%s:disabled" % hitboxShape.get_path())
				techniqueAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				techniqueAnim.track_insert_key(track_idx, 0, true)
				techniqueAnim.track_insert_key(track_idx, technique_data.hitboxes[i].startup/60.0, false)
				techniqueAnim.track_insert_key(track_idx, (technique_data.hitboxes[i].startup + technique_data.hitboxes[i].active)/60.0, true)
				track_idx = techniqueAnim.add_track(Animation.TYPE_VALUE)
				techniqueAnim.track_set_path(track_idx, "%s:visible" % hitboxShape.get_path())
				techniqueAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				techniqueAnim.track_insert_key(track_idx, 0, false)
				techniqueAnim.track_insert_key(track_idx, technique_data.hitboxes[i].startup/60.0, true)
				techniqueAnim.track_insert_key(track_idx, (technique_data.hitboxes[i].startup + technique_data.hitboxes[i].active)/60.0, false)
				
				# set keys for reset
				track_idx = resetAnim.add_track(Animation.TYPE_VALUE)
				resetAnim.track_set_path(track_idx, "%s:disabled" % hitboxShape.get_path())
				resetAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				resetAnim.track_insert_key(track_idx, 0, true)
				track_idx = resetAnim.add_track(Animation.TYPE_VALUE)
				resetAnim.track_set_path(track_idx, "%s:visible" % hitboxShape.get_path())
				resetAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				resetAnim.track_insert_key(track_idx, 0, false)
				# set keys for hitstun
				track_idx = hitstunAnim.add_track(Animation.TYPE_VALUE)
				hitstunAnim.track_set_path(track_idx, "%s:disabled" % hitboxShape.get_path())
				hitstunAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstunAnim.track_insert_key(track_idx, 0, true)
				track_idx = hitstunAnim.add_track(Animation.TYPE_VALUE)
				hitstunAnim.track_set_path(track_idx, "%s:visible" % hitboxShape.get_path())
				hitstunAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstunAnim.track_insert_key(track_idx, 0, false)
				
	loadout.setup_techniques()

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
	
	if %StateMachine.currentState is ActionableState:
		%SideTracker.set_side_lock(false)
	else:
		%SideTracker.set_side_lock(true)
		
	if %SideTracker.canFlip:
		face_opponent()
	
	if %StateMachine.currentState is not StateHitstun \
	and %StateMachine.currentState is not StateClashing \
	and %StateMachine.currentState is not StateClashLose:
		#currentActionGoal += sta
		var rng_roll: int = randi() % (maxSta + 1) + minSta
		currentActionGoal += rng_roll
	
	loadout.techniques_check()
	if loadout.techniqueToExecute != null:
		broadcastAction.emit(GlobalValues.ACTION.ATTACK)
	else:
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

func get_hit(hitbox: HitBox, hurtbox: Hurtbox):
	var parent = hitbox.owner
	if parent != self:
		var hitbox_location : Vector2 = hitbox.get_children()[0].global_position
		var hurtbox_location : Vector2 = hurtbox.get_children()[0].global_position
		var vfx_pos = (hitbox_location + hurtbox_location) / 2
		var vfx_type : VFXManager.VFX_TYPE
		
		print("Attack detected, parent = " + parent.characterName + " dmg = " + str(hitbox.damage) + ", groupname = " + hitbox.groupName)
		var chosenHitState = "Hitstun"
		vfx_type = VFXManager.VFX_TYPE.HIT
		
		var knockbackDirectionMod : int = 1
		if is_char_facing_right():
			knockbackDirectionMod = -1
		
		# Check character currently moving backwards, char blocks
		if %StateMachine.currentState is StateMoveBkwd or %StateMachine.currentState is StateBlockstun:
			chosenHitState = "Blockstun"
			vfx_type = VFXManager.VFX_TYPE.BLOCK
			hitstun = hitbox.blockstun
			hitknockbackX = hitbox.blockbackX * knockbackDirectionMod
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
			hitknockbackX = hitbox.knockbackX * knockbackDirectionMod
			hitknockbackY = hitbox.knockbackY

			# Check for KO
			if health - hitbox.damage <= 0:
				chosenHitState = "Lose"
				health = 0
				broadcastWinState.emit()
			else:
				health -= hitbox.damage
				
		var vfx : VFX = VFXManager.spawn_vfx(vfx_type, vfx_pos, knockbackDirectionMod)
		vfx.freeze_frames = hitstop_frames
		
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

func get_side() -> int:
	return %SideTracker.side

func toggle_collision(canCollide : bool) -> void:
	if !canCollide:
		pass
	self.set_collision_layer_value(1, canCollide)
	self.set_collision_mask_value(1, canCollide)
	
func face_opponent() -> void:
	var facingRight : bool = is_char_facing_right()
	%SideTracker.set_facing_direction(facingRight)

func is_char_facing_right() -> bool:
	return position.x < opponent.position.x
