extends CharacterBody2D
class_name Character

#signal changeState(newState: String)
#signal broadcastAtkStart()
signal broadcastAtkActiveEnd()
signal broadcastAction(action : GlobalValues.ACTION)
signal broadcastClashResult(result : bool)
signal broadcastLose()
signal shakeCamera(amount : float)
signal popupAffinity(name: String)

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
var clashResult : bool = false
var oppClashResult : bool = false

var hitstun : float = 0
var hitknockbackX : float = 0.000
var hitknockbackY : float = 0.000
var health : int = maxHP
var loadout : Loadout
var affMgr : AffinityManager
var stateMachine : StateMachine
var stateManager : StateManager

## Set opponent character here
@export var opponent : Character

@export var affinityBonuses : Array[PackedScene]

var hitstop_frames: int = 0
var stored_velocity: Vector2 = Vector2.ZERO
var was_in_hitstop: bool = false
var hit_by: Array[HitBox] = []
var hurtboxes_hit: Array[Hurtbox] = []

var velocity_x_before_wall : float = 0

func _enter_tree() -> void:
	loadout = %Loadout
	affMgr = %AffinityManager
	stateMachine = %StateMachine
	stateManager = %StateManager
	characterName = characterData.characterName
	animLibName = characterData.animLibName
	# clear animation libraries
	var libs : Array[StringName] = %AnimationPlayer.get_animation_library_list()
	for lib in libs:
		%AnimationPlayer.remove_animation_library(lib)
	# add the needed animation library
	var copiedLib : AnimationLibrary = characterData.animLib.duplicate(true)
	%AnimationPlayer.add_animation_library(animLibName, copiedLib)
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
	affMgr.setup_affinity_bonuses(affinityBonuses)
	GlobalValues.connect("updateDataToChar", _on_tick)
	if opponent != null:
		opponent.connect("broadcastAction", decide_action)
		opponent.connect("broadcastAtkActiveEnd", on_atk_active_end_signal_rcvd)
		opponent.connect("broadcastClashResult", on_clash_result_rcvd)
		opponent.connect("broadcastLose", check_win)
		distance = abs(opponent.position.x - position.x)
	
	stateManager.run_strategy_mods(strategy)

## SETUP functions
func setup_loadout(techniqueDataList : Array[TechniqueData]) -> void:
	var resetAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/RESET")
	var hitstunAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/hitstun")
	techniqueDataList.append(characterData.baseAtkData)
	
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
			
			
			for j in technique_data.hurtboxes.size():
				var hurtboxShape : CollisionShape2D = CollisionShape2D.new()
				hurtboxShape.shape = technique_data.hurtboxes[j].hurtboxShape
				hurtboxShape.disabled = true
				hurtboxShape.visible = false
				hurtboxShape.debug_color = Color(0, 0.6, 0, 0.42)
				hurtboxShape.position = technique_data.hurtboxes[j].location
				%CharacterHurtbox.add_child(hurtboxShape)
				
				# set keys for technique
				var techniqueAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/" + techniqueNode.animName)
				var track_idx = techniqueAnim.add_track(Animation.TYPE_VALUE)
				techniqueAnim.track_set_path(track_idx, "%s:disabled" % hurtboxShape.get_path())
				techniqueAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				techniqueAnim.track_insert_key(track_idx, 0, true)
				techniqueAnim.track_insert_key(track_idx, technique_data.hurtboxes[j].startup/60.0, false)
				techniqueAnim.track_insert_key(track_idx, (technique_data.hurtboxes[j].startup + technique_data.hurtboxes[j].active)/60.0, true)
				
				track_idx = techniqueAnim.add_track(Animation.TYPE_VALUE)
				techniqueAnim.track_set_path(track_idx, "%s:visible" % hurtboxShape.get_path())
				techniqueAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				techniqueAnim.track_insert_key(track_idx, 0, false)
				techniqueAnim.track_insert_key(track_idx, technique_data.hurtboxes[j].startup/60.0, true)
				techniqueAnim.track_insert_key(track_idx, (technique_data.hurtboxes[j].startup + technique_data.hurtboxes[j].active)/60.0, false)
				
				# set keys for reset
				track_idx = resetAnim.add_track(Animation.TYPE_VALUE)
				resetAnim.track_set_path(track_idx, "%s:disabled" % hurtboxShape.get_path())
				resetAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				resetAnim.track_insert_key(track_idx, 0, true)
				
				track_idx = resetAnim.add_track(Animation.TYPE_VALUE)
				resetAnim.track_set_path(track_idx, "%s:visible" % hurtboxShape.get_path())
				resetAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				resetAnim.track_insert_key(track_idx, 0, false)
				# set keys for hitstun
				track_idx = hitstunAnim.add_track(Animation.TYPE_VALUE)
				hitstunAnim.track_set_path(track_idx, "%s:disabled" % hurtboxShape.get_path())
				hitstunAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstunAnim.track_insert_key(track_idx, 0, true)
				
				track_idx = hitstunAnim.add_track(Animation.TYPE_VALUE)
				hitstunAnim.track_set_path(track_idx, "%s:visible" % hurtboxShape.get_path())
				hitstunAnim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstunAnim.track_insert_key(track_idx, 0, false)
				
	loadout.setup_techniques()

func unload_loadout() -> void:
	var resetAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/RESET")
	var hitstunAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/hitstun")
	for technique in loadout.get_children():
		if technique is Technique:
			var techniqueAnim : Animation = %AnimationPlayer.get_animation(animLibName + "/" + technique.animName)
			for child in %SideTracker.get_children():
				if child is HitBox:
					for shape in child.get_children():
						var disabledTechTrack : int = techniqueAnim.find_track("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
						if disabledTechTrack != -1:
							techniqueAnim.remove_track(disabledTechTrack)
						var visibleTechTrack : int = techniqueAnim.find_track("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
						if visibleTechTrack != -1:
							techniqueAnim.remove_track(visibleTechTrack)
						if disabledTechTrack != -1 and visibleTechTrack != -1:
							var disabledResetTrack : int = resetAnim.find_track("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabledResetTrack != -1:
								resetAnim.remove_track(disabledResetTrack)
							var visibleResetTrack : int = resetAnim.find_track("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visibleResetTrack != -1:
								resetAnim.remove_track(visibleResetTrack)
							var disabledHitstunTrack : int = hitstunAnim.find_track("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabledHitstunTrack != -1:
								hitstunAnim.remove_track(disabledHitstunTrack)
							var visibleHitstunTrack : int = hitstunAnim.find_track("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visibleHitstunTrack != -1:
								hitstunAnim.remove_track(visibleHitstunTrack)
				if child is Hurtbox:
					for shape in child.get_children():
						var disabledTechTrack : int = techniqueAnim.find_track("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
						if disabledTechTrack != -1:
							techniqueAnim.remove_track(disabledTechTrack)
						var visibleTechTrack : int = techniqueAnim.find_track("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
						if visibleTechTrack != -1:
							techniqueAnim.remove_track(visibleTechTrack)
						if disabledTechTrack != -1 and visibleTechTrack != -1:
							var disabledResetTrack : int = resetAnim.find_track("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabledResetTrack != -1:
								resetAnim.remove_track(disabledResetTrack)
							var visibleResetTrack : int = resetAnim.find_track("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visibleResetTrack != -1:
								resetAnim.remove_track(visibleResetTrack)
							var disabledHitstunTrack : int = hitstunAnim.find_track("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabledHitstunTrack != -1:
								hitstunAnim.remove_track(disabledHitstunTrack)
							var visibleHitstunTrack : int = hitstunAnim.find_track("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visibleHitstunTrack != -1:
								hitstunAnim.remove_track(visibleHitstunTrack)

## initial PHYSICS function
func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity
	if hitknockbackX != 0:
		velocity.x = hitknockbackX
		hitknockbackX = 0.000
		hitknockbackY = 0.000
	else:
		velocity.x = lerp(velocity.x, 0.000, 0.250)


## STRATEGY related functions
func check_can_attack():
	return (currentActionGoal >= actionGoalTotal && 			# Action goal check
			distance <= minDistance && 							# Distance check (attack close enough to hit)
			%StateMachine.currentState is not StateHitstun)		# Histun check

func check_want_to_attack():
	return (currentActionGoal >= actionGoalTotal && 			# Action goal check
			%StateMachine.currentState is not StateHitstun && 
			%StateMachine.currentState is not StateBlockstun)		# Hitstun check

func min_distance_hit():
	return distance <= minDistance

func decide_action(oppAction: GlobalValues.ACTION):
	if oppAction == GlobalValues.ACTION.ATTACK:
		opponentIsAttacking = true

func on_atk_active_end_signal_rcvd():
	opponentIsAttacking = false
	
func broadcast_atk_active_end():
	broadcastAtkActiveEnd.emit()
	opponentIsAttacking = false

## Check whether the char wins or loses (double down) after receiving the lose
## signal from the opponent.
func check_win():
	# TODO: actually we need to check if opponent also got this
	var chosenState = ""
	var currentState = %StateMachine.currentState
	
	if not opponentIsAttacking:
		chosenState = "Win"
		
		# Happens during 2nd char check during double down, opponentIsAttacking
		# no longer true but current health is already set to 0. So current 
		# char should lose
		if health == 0:
			return
		
	# stop doing stuff
	else:
		return
	
	%StateMachine.on_child_transition(currentState, chosenState)


## CLASH related functions
func clash_check():
	var win_clash_chance = (float(atk + def) / float(atk + def + opponent.atk + opponent.def)) * 100
	var win_clash_check = randi() % 100
	return win_clash_check <= win_clash_chance

func determine_clash_winner():
	affMgr.check_event_bonuses()
	if !clashResult:
		clashResult = clash_check()
	broadcastClashResult.emit(clashResult)
	
func on_clash_result_rcvd(result: bool):
	oppClashResult = result
	print(opponent.characterName + " Clash Result: " + str(oppClashResult))


# What the character does each TICK
func _on_tick(rcvDistance: float, rcvTickCount: int):
	distance = rcvDistance
	tickCount = rcvTickCount
	
	stateManager.run_full_logic()


# on character getting HIT
func get_hit(hitbox: HitBox, hurtbox: Hurtbox) -> void:
	var parent : Character = hitbox.owner
	if parent != self:
		hit_by.append(hitbox)
		hurtboxes_hit.append(hurtbox)

func get_hit_logic(hitbox: HitBox, hurtbox: Hurtbox):
	var parent : Character = hitbox.owner
	# choose where to spawn the vfx
	var vfx_pos : Vector2 = get_intersection_midpoint(hitbox, hurtbox)
	# holds the type of vfx to be initialized at the end of the process
	var vfx_type : VFXManager.VFX_TYPE
	var final_hitstop : int = 0
	var final_hitstop_owner : int = 0
	
	# hit facing direction management
	var knockbackDirectionMod : int = 1
	if is_char_facing_right():
		knockbackDirectionMod = -1
		
	print("Attack detected, parent = " + parent.characterName + " dmg = " + str(hitbox.damage) + ", groupname = " + hitbox.groupName)
	
	vfx_type = VFXManager.VFX_TYPE.HIT
	var outputHealth = health
	final_hitstop = max(hitstop_frames, hitbox.hitstopFrames)
	final_hitstop_owner = max(hitbox.owner.hitstop_frames, hitbox.hitstopFrames)
	hitstun = hitbox.hitstun
	hitknockbackX = hitbox.knockbackX * knockbackDirectionMod
	hitknockbackY = hitbox.knockbackY
	outputHealth = take_damage_hit(parent.calc_initial_damage(hitbox.damage))
	
	# vfx, hitstop, camera and sprite shake handling
	hitstop_frames = final_hitstop
	hitbox.owner.hitstop_frames = final_hitstop_owner
	var vfx : VFX = VFXManager.spawn_vfx(vfx_type, vfx_pos, knockbackDirectionMod)
	vfx.add_to_group("vfx", false)
	for vfxNode in get_tree().get_nodes_in_group("vfx"):
		vfxNode.freeze_frames = hitstop_frames
	shakeCamera.emit((hitstop_frames * 1.0/5) * 0.2)
	%Sprite.add_trauma((hitstop_frames * 1.0/5) * 0.2)
	
	# final outcome
	health = outputHealth
	opponentIsAttacking = false

func get_block_logic(hitbox: HitBox, hurtbox: Hurtbox):
	var parent : Character = hitbox.owner
	if parent != self:
		# choose where to spawn the vfx
		var vfx_pos : Vector2 = get_intersection_midpoint(hitbox, hurtbox)
		# holds the type of vfx to be initialized at the end of the process
		var vfx_type : VFXManager.VFX_TYPE
		var final_hitstop : int = 0
		var final_hitstop_owner : int = 0
		
		# hit facing direction management
		var knockbackDirectionMod : int = 1
		if is_char_facing_right():
			knockbackDirectionMod = -1
			
		print("Attack detected, parent = " + parent.characterName + " dmg = " + str(hitbox.damage) + ", groupname = " + hitbox.groupName)
		
		vfx_type = VFXManager.VFX_TYPE.BLOCK
		@warning_ignore("integer_division")
		final_hitstop = max(hitstop_frames, hitbox.hitstopFrames/2)
		@warning_ignore("integer_division")
		final_hitstop_owner = max(hitbox.owner.hitstop_frames, hitbox.hitstopFrames/2)
		hitstun = hitbox.blockstun
		hitknockbackX = hitbox.blockbackX * knockbackDirectionMod
		hitknockbackY = hitbox.blockbackY
		# Check for KO (no chip kill)
		var outputHealth = take_damage_block(parent.calc_initial_damage(hitbox.damage))
		
		# vfx, hitstop, camera and sprite shake handling
		hitstop_frames = final_hitstop
		hitbox.owner.hitstop_frames = final_hitstop_owner
		var vfx : VFX = VFXManager.spawn_vfx(vfx_type, vfx_pos, knockbackDirectionMod)
		vfx.add_to_group("vfx", false)
		for vfxNode in get_tree().get_nodes_in_group("vfx"):
			vfxNode.freeze_frames = hitstop_frames
		shakeCamera.emit((hitstop_frames * 1.0/5) * 0.2)
		%Sprite.add_trauma((hitstop_frames * 1.0/5) * 0.2)
		
		# final outcome
		health = outputHealth
		opponentIsAttacking = false

func get_attacked_outcome() -> String:
	var outcomeState = ""
	affMgr.check_event_bonuses()
	if health <= 0:
		health = 0
		outcomeState = "Lose"
	return outcomeState


## DAMAGE calc functions
func calc_initial_damage(value : int) -> int:
	return value + atk

func take_damage_hit(value : int) -> int:
	var outputHealth = health
	var actualDamage : int = value - def
	outputHealth -= actualDamage
	if outputHealth < 0:
		outputHealth = 0
	return outputHealth

func take_damage_block(value : int) -> int:
	var outputHealth = health
	@warning_ignore("narrowing_conversion")
	var actualDamage : int = (value - def) * 0.3
	outputHealth -= actualDamage
	if outputHealth <= 0:
		outputHealth = 1
	return outputHealth


## HELPER functions
func get_side() -> int:
	return %SideTracker.side

func toggle_collision(canCollide : bool) -> void:
	if !canCollide:
		pass
	self.set_collision_layer_value(1, canCollide)
	self.set_collision_mask_value(1, canCollide)

func toggle_hurtbox(hurtbox_active : bool) -> void:
	%CharacterHurtbox.monitorable = hurtbox_active
	%CharacterHurtbox.monitoring = hurtbox_active
	
func face_opponent() -> void:
	var facingRight : bool = is_char_facing_right()
	%SideTracker.set_facing_direction(facingRight)

func is_char_facing_right() -> bool:
	return position.x < opponent.position.x

func get_intersection_midpoint(hitbox: HitBox, hurtbox: Hurtbox) -> Vector2:
	var hitbox_location : Vector2 = hitbox.get_children()[0].global_transform.origin
	var hurtbox_location : Vector2 = hurtbox.get_children()[0].global_transform.origin
	var hitbox_size : Vector2 = hitbox.get_children()[0].shape.size
	var hurtbox_size : Vector2 = hurtbox.get_children()[0].shape.size
	var vfx_pos : Vector2 = (hitbox_location + hurtbox_location) / 2
	
	var hitboxRect : Rect2 = Rect2(hitbox_location - hitbox_size/2, hitbox_size)
	var hurtboxRect : Rect2 = Rect2(hurtbox_location - hurtbox_size/2, hurtbox_size)
	var intersection : Rect2 = hitboxRect.intersection(hurtboxRect)
	if intersection.size != Vector2.ZERO:
		vfx_pos = intersection.position + intersection.size/2
	return vfx_pos
