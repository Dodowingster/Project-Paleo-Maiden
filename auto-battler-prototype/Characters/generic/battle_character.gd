class_name Character
extends CharacterBody2D

#signal changeState(newState: String)
#signal broadcastAtkStart()
signal broadcast_atk_active_end()
signal broadcast_clash_result(result : bool)
signal broadcast_lose()
signal shake_camera(amount : float)
signal popup_affinity(name: String)

@export var character_data : CharacterData

@export var start_facing_right: bool = true

## Set opponent character here
@export var opponent : Character

@export var affinity_bonuses : Array[PackedScene]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_action_goal: int = 0
var action_stocks_total : int = 3
var current_action_stock: int = 0
var opponent_is_attacking: bool = false
var can_clash = false
var clash_result : bool = false
var opp_clash_result : bool = false

var hitstun : float = 0
var hit_knockback_x : float = 0.000
var hit_knockback_y : float = 0.000
var health : int = max_hp
var loadout : Loadout
var aff_mgr : AffinityManager
var state_machine : CharStateMachine
var state_manager : StateManager

var hitstop_frames: int = 0
var stored_velocity: Vector2 = Vector2.ZERO
var was_in_hitstop: bool = false
var hit_by: Array[HitBox] = []
var hurtboxes_hit: Array[Hurtbox] = []

var velocity_x_before_wall : float = 0

## Mainly for debugging and identification
@onready var character_name : String
@onready var anim_lib_name : String
## Base stat to calculate attack damage from
@onready var atk: int  # currently unused
## Base stat to calculate damage taken
@onready var def: int  # currently unused
## Determines general move speed (in pixels I think?)
@onready var spd: int
## Minimum stamina roll to add to action goal
@onready var min_sta: int
## Maximum stamina roll to add to action goal
@onready var max_sta: int
## Maximum HP
@onready var max_hp: int

@onready var strategy: GlobalValues.Strategy

@onready var distance: float
@onready var tick_count: int

## Determines the maximum distance between characters to trigger
## their attack logic (for AGGRESSIVE strategy)
@onready var min_distance: int
@onready var max_distance: int
## Modifies base forward movement speed
@onready var forward_spd_mult: float
## Modifies base backward movement speed
@onready var backward_spd_mult: float
## Modifies dash forward movement speed
@onready var forward_dash_spd_mult: float
## Modifies dash backward movement speed
@onready var backward_dash_spd_mult: float

## Determines number of action goal points needed to perform an attack
@onready var action_goal_total: int


# initial code to run before children code
func _enter_tree() -> void:
	loadout = %Loadout
	aff_mgr = %AffinityManager
	state_machine = %StateMachine
	state_manager = %StateManager
	character_name = character_data.character_name
	anim_lib_name = character_data.anim_lib_name
	# clear animation libraries
	var libs : Array[StringName] = %AnimationPlayer.get_animation_library_list()
	for lib in libs:
		%AnimationPlayer.remove_animation_library(lib)
	# add the needed animation library
	var copied_lib : AnimationLibrary = character_data.anim_lib.duplicate(true)
	%AnimationPlayer.add_animation_library(anim_lib_name, copied_lib)
	atk = character_data.atk
	def = character_data.def
	spd = character_data.spd
	min_sta = character_data.min_sta
	max_sta = character_data.max_sta
	max_hp = character_data.max_hp
	strategy = character_data.strategy
	min_distance = character_data.min_distance
	max_distance = character_data.max_distance
	forward_spd_mult = character_data.forward_spd_mult
	backward_spd_mult = character_data.backward_spd_mult
	forward_dash_spd_mult = character_data.forward_dash_spd_mult
	backward_dash_spd_mult = character_data.backward_dash_spd_mult
	action_goal_total = character_data.action_goal_total

	health = character_data.current_hp

# code to run after children are ready
func _ready() -> void:
	var dash_fwd_state : State = state_machine.states.get("dashforward")
	var dash_bkwd_state : State = state_machine.states.get("dashbackward")
	if dash_fwd_state is StateDashFwd:
		dash_fwd_state.time_till_actionable = character_data.forward_dash_min_duration
	if dash_bkwd_state is StateDashBkwd:
		dash_bkwd_state.time_till_actionable = character_data.backward_dash_min_duration

	%SideTracker.set_facing_direction(start_facing_right)
	aff_mgr.setup_affinity_bonuses(affinity_bonuses)
	GlobalValues.connect("update_data_to_char", _on_tick)
	if opponent != null:
		opponent.connect("broadcast_atk_active_end", on_atk_active_end_signal_rcvd)
		opponent.connect("broadcast_clash_result", on_clash_result_rcvd)
		opponent.connect("broadcast_lose", check_win)
		distance = abs(opponent.position.x - position.x)


## SETUP functions
# due to the current way we set up hitboxes and hurtboxes,
# we manually add them into animation tracks
# for relevant moves before adding them to the character's loadout
# TODO: find a better way to do this
func setup_loadout(technique_data_list : Array[TechniqueData]) -> void:
	var reset_anim : Animation = %AnimationPlayer.get_animation(anim_lib_name + "/RESET")
	var hitstun_anim : Animation = %AnimationPlayer.get_animation(anim_lib_name + "/hitstun")
	technique_data_list.append(character_data.base_atk_data)

	for technique_data in technique_data_list:
		var technique_node = technique_data.technique.instantiate()
		if technique_node is Technique:
			loadout.add_child(technique_node)
			for i in technique_data.hitboxes.size():
				var technique_hitbox : HitBox = HitBox.new()
				technique_hitbox.damage = technique_data.hitboxes[i].damage
				technique_hitbox.hitstun = technique_data.hitboxes[i].hitstun
				technique_hitbox.blockstun = technique_data.hitboxes[i].blockstun
				technique_hitbox.knockback_x = technique_data.hitboxes[i].knockback_x
				technique_hitbox.knockback_y = technique_data.hitboxes[i].knockback_y
				technique_hitbox.blockback_x = technique_data.hitboxes[i].blockback_x
				technique_hitbox.blockback_y = technique_data.hitboxes[i].blockback_y
				technique_hitbox.hitstop_frames = technique_data.hitboxes[i].hitstop_frames
				technique_hitbox.is_multi_hit = technique_data.hitboxes[i].is_multi_hit
				technique_hitbox.group_name = technique_data.hitboxes[i].group_name

				var hitbox_shape : CollisionShape2D = CollisionShape2D.new()
				hitbox_shape.shape = technique_data.hitboxes[i].hitbox_shape
				hitbox_shape.disabled = true
				hitbox_shape.visible = false
				hitbox_shape.debug_color = Color(0.69, 0, 0, 0.41)
				hitbox_shape.position = technique_data.hitboxes[i].location
				technique_hitbox.add_child(hitbox_shape)
				%SideTracker.add_child(technique_hitbox)
				technique_hitbox.owner = self

				# set keys for technique
				var technique_anim : Animation = %AnimationPlayer.get_animation\
				(anim_lib_name + "/" + technique_node.anim_name)
				var track_idx = technique_anim.add_track(Animation.TYPE_VALUE)
				technique_anim.track_set_path(track_idx, "%s:disabled" % hitbox_shape.get_path())
				technique_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				technique_anim.track_insert_key(track_idx, 0, true)
				technique_anim.track_insert_key(track_idx, technique_data.hitboxes[i].startup/60.0, false)
				technique_anim.track_insert_key(track_idx, \
				(technique_data.hitboxes[i].startup + technique_data.hitboxes[i].active)/60.0, true)

				track_idx = technique_anim.add_track(Animation.TYPE_VALUE)
				technique_anim.track_set_path(track_idx, "%s:visible" % hitbox_shape.get_path())
				technique_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				technique_anim.track_insert_key(track_idx, 0, false)
				technique_anim.track_insert_key(track_idx, technique_data.hitboxes[i].startup/60.0, true)
				technique_anim.track_insert_key(track_idx, \
				(technique_data.hitboxes[i].startup + technique_data.hitboxes[i].active)/60.0, false)

				# set keys for reset
				track_idx = reset_anim.add_track(Animation.TYPE_VALUE)
				reset_anim.track_set_path(track_idx, "%s:disabled" % hitbox_shape.get_path())
				reset_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				reset_anim.track_insert_key(track_idx, 0, true)

				track_idx = reset_anim.add_track(Animation.TYPE_VALUE)
				reset_anim.track_set_path(track_idx, "%s:visible" % hitbox_shape.get_path())
				reset_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				reset_anim.track_insert_key(track_idx, 0, false)
				# set keys for hitstun
				track_idx = hitstun_anim.add_track(Animation.TYPE_VALUE)
				hitstun_anim.track_set_path(track_idx, "%s:disabled" % hitbox_shape.get_path())
				hitstun_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstun_anim.track_insert_key(track_idx, 0, true)

				track_idx = hitstun_anim.add_track(Animation.TYPE_VALUE)
				hitstun_anim.track_set_path(track_idx, "%s:visible" % hitbox_shape.get_path())
				hitstun_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstun_anim.track_insert_key(track_idx, 0, false)


			for j in technique_data.hurtboxes.size():
				var hurtbox_shape : CollisionShape2D = CollisionShape2D.new()
				hurtbox_shape.shape = technique_data.hurtboxes[j].hurtbox_shape
				hurtbox_shape.disabled = true
				hurtbox_shape.visible = false
				hurtbox_shape.debug_color = Color(0, 0.6, 0, 0.42)
				hurtbox_shape.position = technique_data.hurtboxes[j].location
				%CharacterHurtbox.add_child(hurtbox_shape)

				# set keys for technique
				var technique_anim : Animation = %AnimationPlayer.get_animation\
				(anim_lib_name + "/" + technique_node.anim_name)
				var track_idx = technique_anim.add_track(Animation.TYPE_VALUE)
				technique_anim.track_set_path(track_idx, "%s:disabled" % hurtbox_shape.get_path())
				technique_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				technique_anim.track_insert_key(track_idx, 0, true)
				technique_anim.track_insert_key(track_idx, technique_data.hurtboxes[j].startup/60.0, false)
				technique_anim.track_insert_key(track_idx, \
				(technique_data.hurtboxes[j].startup + technique_data.hurtboxes[j].active)/60.0, true)

				track_idx = technique_anim.add_track(Animation.TYPE_VALUE)
				technique_anim.track_set_path(track_idx, "%s:visible" % hurtbox_shape.get_path())
				technique_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				technique_anim.track_insert_key(track_idx, 0, false)
				technique_anim.track_insert_key(track_idx, technique_data.hurtboxes[j].startup/60.0, true)
				technique_anim.track_insert_key(track_idx, \
				(technique_data.hurtboxes[j].startup + technique_data.hurtboxes[j].active)/60.0, false)

				# set keys for reset
				track_idx = reset_anim.add_track(Animation.TYPE_VALUE)
				reset_anim.track_set_path(track_idx, "%s:disabled" % hurtbox_shape.get_path())
				reset_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				reset_anim.track_insert_key(track_idx, 0, true)

				track_idx = reset_anim.add_track(Animation.TYPE_VALUE)
				reset_anim.track_set_path(track_idx, "%s:visible" % hurtbox_shape.get_path())
				reset_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				reset_anim.track_insert_key(track_idx, 0, false)
				# set keys for hitstun
				track_idx = hitstun_anim.add_track(Animation.TYPE_VALUE)
				hitstun_anim.track_set_path(track_idx, "%s:disabled" % hurtbox_shape.get_path())
				hitstun_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstun_anim.track_insert_key(track_idx, 0, true)

				track_idx = hitstun_anim.add_track(Animation.TYPE_VALUE)
				hitstun_anim.track_set_path(track_idx, "%s:visible" % hurtbox_shape.get_path())
				hitstun_anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
				hitstun_anim.track_insert_key(track_idx, 0, false)

	loadout.setup_techniques()
	%AnimationPlayer.play(anim_lib_name + "/RESET")

# to restore animation tracks to their original form,
# we remove anything we added before removing the techniques from a character's loadout
func unload_loadout() -> void:
	var reset_anim : Animation = %AnimationPlayer.get_animation(anim_lib_name + "/RESET")
	var hitstun_anim : Animation = %AnimationPlayer.get_animation(anim_lib_name + "/hitstun")
	for technique in loadout.get_children():
		if technique is Technique:
			var technique_anim : Animation = %AnimationPlayer.get_animation\
			(anim_lib_name + "/" + technique.anim_name)
			for child in %SideTracker.get_children():
				if child is HitBox:
					for shape in child.get_children():
						var disabled_tech_track : int = technique_anim.find_track\
						("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
						if disabled_tech_track != -1:
							technique_anim.remove_track(disabled_tech_track)
						var visible_tech_track : int = technique_anim.find_track\
						("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
						if visible_tech_track != -1:
							technique_anim.remove_track(visible_tech_track)
						if disabled_tech_track != -1 and visible_tech_track != -1:
							var disabled_reset_track : int = reset_anim.find_track\
							("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabled_reset_track != -1:
								reset_anim.remove_track(disabled_reset_track)
							var visible_reset_track : int = reset_anim.find_track\
							("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visible_reset_track != -1:
								reset_anim.remove_track(visible_reset_track)
							var disabled_hitstun_track : int = hitstun_anim.find_track\
							("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabled_hitstun_track != -1:
								hitstun_anim.remove_track(disabled_hitstun_track)
							var visible_hitstun_track : int = hitstun_anim.find_track\
							("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visible_hitstun_track != -1:
								hitstun_anim.remove_track(visible_hitstun_track)
				if child is Hurtbox:
					for shape in child.get_children():
						var disabled_tech_track : int = technique_anim.find_track\
						("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
						if disabled_tech_track != -1:
							technique_anim.remove_track(disabled_tech_track)
						var visible_tech_track : int = technique_anim.find_track\
						("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
						if visible_tech_track != -1:
							technique_anim.remove_track(visible_tech_track)
						if disabled_tech_track != -1 and visible_tech_track != -1:
							var disabled_reset_track : int = reset_anim.find_track\
							("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabled_reset_track != -1:
								reset_anim.remove_track(disabled_reset_track)
							var visible_reset_track : int = reset_anim.find_track\
							("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visible_reset_track != -1:
								reset_anim.remove_track(visible_reset_track)
							var disabled_hitstun_track : int = hitstun_anim.find_track\
							("%s:disabled" % shape.get_path(), Animation.TYPE_VALUE)
							if disabled_hitstun_track != -1:
								hitstun_anim.remove_track(disabled_hitstun_track)
							var visible_hitstun_track : int = hitstun_anim.find_track\
							("%s:visible" % shape.get_path(), Animation.TYPE_VALUE)
							if visible_hitstun_track != -1:
								hitstun_anim.remove_track(visible_hitstun_track)


## initial PHYSICS function
# to be used in the state machine, to handle physics
func set_char_velocity(_delta:float):
	if not is_on_floor():
		velocity.y += gravity
	if hit_knockback_x != 0:
		velocity.x = hit_knockback_x
		hit_knockback_x = 0.000
		hit_knockback_y = 0.000
	else:
		velocity.x = lerp(velocity.x, 0.000, 0.250)


## Strategy related functions
func check_can_attack():
	return (current_action_stock > 0 &&
			distance <= max_distance)

func check_want_to_attack():
	return (current_action_stock > 0)		# Hitstun check

func check_can_clash():
	return(min_distance_hit() and opponent.min_distance_hit() and can_clash and opponent.can_clash)

func min_distance_hit():
	return distance <= min_distance

func in_attack_range():
	return distance <= max_distance

func on_atk_active_end_signal_rcvd():
	opponent_is_attacking = false

func broadcast_attack_active_end():
	broadcast_atk_active_end.emit()
	opponent_is_attacking = false

## Check whether the char wins or loses (double down) after receiving the lose
## signal from the opponent.
func check_win():
	var chosen_state = ""
	var current_state = %StateMachine.current_state

	if not opponent_is_attacking:
		chosen_state = "Win"

		# Happens during 2nd char check during double down, opponent_is_attacking
		# no longer true but current health is already set to 0. So current
		# char should lose
		if health == 0:
			return

	# stop doing stuff
	else:
		return

	%StateMachine.on_child_transition(current_state, chosen_state)


## CLASH related functions
func clash_check():
	var win_clash_chance = (float(atk + def) / float(atk + def + opponent.atk + opponent.def)) * 100
	var win_clash_check = randi() % 100
	return win_clash_check <= win_clash_chance

func determine_clash_winner():
	aff_mgr.check_event_bonuses()
	if !clash_result:
		clash_result = clash_check()
	broadcast_clash_result.emit(clash_result)

func on_clash_result_rcvd(result: bool):
	opp_clash_result = result
	print(opponent.character_name + " Clash Result: " + str(opp_clash_result))


# What the character does each TICK
func _on_tick(rcv_distance: float, rcv_tick_count: int):
	distance = rcv_distance
	tick_count = rcv_tick_count

func _process(_delta: float) -> void:
	state_manager.run_full_logic()


# on character getting HIT
func get_hit(hitbox: HitBox, hurtbox: Hurtbox) -> void:

	var parent = hitbox.owner
	if parent is Projectile:
		parent = parent.projectile_owner
	if parent != self:
		hit_by.append(hitbox)
		hurtboxes_hit.append(hurtbox)

func get_hit_logic(hitbox: HitBox, hurtbox: Hurtbox):
	var parent = hitbox.owner
	if parent is Projectile:
		parent = parent.projectile_owner
	# choose where to spawn the vfx
	var vfx_pos : Vector2 = get_intersection_midpoint(hitbox, hurtbox)
	# holds the type of vfx to be initialized at the end of the process
	var vfx_type : VFXManager.VFXType
	var final_hitstop : int = 0
	var final_hitstop_owner : int = 0

	# hit facing direction management
	var knockback_direction_mod : int = 1
	if is_char_facing_right():
		knockback_direction_mod = -1

	print("Attack detected, parent = " + parent.character_name + " dmg = " + \
	str(hitbox.damage) + ", groupname = " + hitbox.group_name)

	vfx_type = VFXManager.VFXType.HIT
	var output_health = health
	final_hitstop = max(hitstop_frames, hitbox.hitstop_frames)
	final_hitstop_owner = max(parent.hitstop_frames, hitbox.hitstop_frames)
	hitstun = hitbox.hitstun
	hit_knockback_x = hitbox.knockback_x * knockback_direction_mod
	hit_knockback_y = hitbox.knockback_y
	output_health = take_damage_hit(parent.calc_initial_damage(hitbox.damage))

	# vfx, hitstop, camera and sprite shake handling
	hitstop_frames = final_hitstop
	parent.hitstop_frames = final_hitstop_owner
	var vfx : VFX = VFXManager.spawn_vfx(vfx_type, vfx_pos, knockback_direction_mod)
	vfx.add_to_group("vfx", false)
	for vfx_node in get_tree().get_nodes_in_group("vfx"):
		vfx_node.freeze_frames = hitstop_frames
	shake_camera.emit((hitstop_frames * 1.0/5) * 0.2)
	%Sprite.add_trauma((hitstop_frames * 1.0/5) * 0.2)

	# final outcome
	health = output_health
	opponent_is_attacking = false

func get_block_logic(hitbox: HitBox, hurtbox: Hurtbox):
	var parent : Character = hitbox.owner
	if parent != self:
		# choose where to spawn the vfx
		var vfx_pos : Vector2 = get_intersection_midpoint(hitbox, hurtbox)
		# holds the type of vfx to be initialized at the end of the process
		var vfx_type : VFXManager.VFXType
		var final_hitstop : int = 0
		var final_hitstop_owner : int = 0

		# hit facing direction management
		var knockback_direction_mod : int = 1
		if is_char_facing_right():
			knockback_direction_mod = -1

		print("Attack detected, parent = " + parent.character_name + " dmg = " + \
		str(hitbox.damage) + ", groupname = " + hitbox.group_name)

		vfx_type = VFXManager.VFXType.BLOCK
		@warning_ignore("integer_division")
		final_hitstop = max(hitstop_frames, hitbox.hitstop_frames/2)
		@warning_ignore("integer_division")
		final_hitstop_owner = max(hitbox.owner.hitstop_frames, hitbox.hitstop_frames/2)
		hitstun = hitbox.blockstun
		hit_knockback_x = hitbox.blockback_x * knockback_direction_mod
		hit_knockback_y = hitbox.blockback_y
		# Check for KO (no chip kill)
		var output_health = take_damage_block(parent.calc_initial_damage(hitbox.damage))

		# vfx, hitstop, camera and sprite shake handling
		hitstop_frames = final_hitstop
		hitbox.owner.hitstop_frames = final_hitstop_owner
		var vfx : VFX = VFXManager.spawn_vfx(vfx_type, vfx_pos, knockback_direction_mod)
		vfx.add_to_group("vfx", false)
		for vfx_node in get_tree().get_nodes_in_group("vfx"):
			vfx_node.freeze_frames = hitstop_frames
		shake_camera.emit((hitstop_frames * 1.0/5) * 0.2)
		%Sprite.add_trauma((hitstop_frames * 1.0/5) * 0.2)

		# final outcome
		health = output_health
		opponent_is_attacking = false

func get_attacked_outcome() -> String:
	var outcome_state = ""
	aff_mgr.check_event_bonuses()
	if health <= 0:
		health = 0
		outcome_state = "Lose"
	return outcome_state


## DAMAGE calc functions
func calc_initial_damage(value : int) -> int:
	return value + atk

func take_damage_hit(value : int) -> int:
	var output_health = health
	var actual_damage : int = value - def
	output_health -= actual_damage
	if output_health < 0:
		output_health = 0
	return output_health

func take_damage_block(value : int) -> int:
	var output_health = health
	@warning_ignore("narrowing_conversion")
	var actual_damage : int = (value - def) * 0.3
	output_health -= actual_damage
	if output_health <= 0:
		output_health = 1
	return output_health


## HELPER functions
func get_side() -> int:
	return %SideTracker.side

func toggle_collision(can_collide : bool) -> void:
	if !can_collide:
		pass
	self.set_collision_layer_value(1, can_collide)
	self.set_collision_mask_value(1, can_collide)

func toggle_hurtbox(hurtbox_active : bool) -> void:
	%CharacterHurtbox.monitorable = hurtbox_active
	%CharacterHurtbox.monitoring = hurtbox_active

func face_opponent() -> void:
	var facing_right : bool = is_char_facing_right()
	%SideTracker.set_facing_direction(facing_right)

func is_char_facing_right() -> bool:
	return position.x < opponent.position.x

func get_intersection_midpoint(hitbox: HitBox, hurtbox: Hurtbox) -> Vector2:
	var hitbox_location : Vector2 = hitbox.get_children()[0].global_transform.origin
	var hurtbox_location : Vector2 = hurtbox.get_children()[0].global_transform.origin
	var hitbox_size : Vector2 = hitbox.get_children()[0].shape.size
	var hurtbox_size : Vector2 = hurtbox.get_children()[0].shape.size
	var vfx_pos : Vector2 = (hitbox_location + hurtbox_location) / 2

	var hitbox_rect : Rect2 = Rect2(hitbox_location - hitbox_size/2, hitbox_size)
	var hurtbox_rect : Rect2 = Rect2(hurtbox_location - hurtbox_size/2, hurtbox_size)
	var intersection : Rect2 = hitbox_rect.intersection(hurtbox_rect)
	if intersection.size != Vector2.ZERO:
		vfx_pos = intersection.position + intersection.size/2
	return vfx_pos
