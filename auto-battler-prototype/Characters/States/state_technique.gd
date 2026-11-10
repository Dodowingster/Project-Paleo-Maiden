class_name StateTechnique
extends State

var anim_list : PackedStringArray = []
var anim_name : String
var last_tick : int = 0
var chosen_technique : Technique
#var spriteOGCoordinates : Vector2 = Vector2.ZERO

@onready var anim_player : AnimationPlayer = %AnimationPlayer


func _ready():
	anim_list = anim_player.get_animation_list()

func enter():
	owner.can_clash = false
	owner.opponent.opponent_is_attacking = true
	chosen_technique = %Loadout.technique_to_execute
	anim_name = owner.anim_lib_name + "/" + chosen_technique.anim_name
	for trigger in chosen_technique.triggers:
		if trigger is CooldownTrigger:
			trigger.reset()
		if trigger is ActionStockTrigger:
			owner.current_action_stock -= 1
	if anim_name in anim_list:
		anim_player.play(anim_name)


func exit():
	for effect in chosen_technique.effects:
		effect.reset()
	anim_player.play(owner.anim_lib_name + "/RESET")


func update(_delta: float):
	for effect in chosen_technique.effects:
		effect.execute_effect(_delta)


func physics_update(_delta: float):
	for effect in chosen_technique.effects:
		effect.execute_physics_effect(_delta)

	if owner.hitstop_frames > 0:
		if not owner.was_in_hitstop:
			owner.stored_velocity = owner.velocity
			owner.was_in_hitstop = true
			anim_player.speed_scale = 0
		owner.velocity = Vector2.ZERO
	else:
		if owner.was_in_hitstop:
			owner.velocity = owner.stored_velocity
			owner.was_in_hitstop = false
			anim_player.speed_scale = 1
	if owner.hitstop_frames > 0:
		#shake_sprite(owner.hitstop_frames, 2)
		owner.hitstop_frames -= 1


#func shake_sprite(currentHitStopFrame: int, pixelShake: int):
	#if currentHitStopFrame % 3 == 0:
		#%Sprite.position.x = spriteOGCoordinates.x + pixelShake
	#elif currentHitStopFrame % 2 == 0:
		#%Sprite.position.x = spriteOGCoordinates.x
	#elif currentHitStopFrame % 1 == 0:
		#%Sprite.position.x = spriteOGCoordinates.x - pixelShake
	#else:
		#%Sprite.position.x = spriteOGCoordinates.x

func _on_animation_player_animation_finished(animation_name: StringName) -> void:
	if animation_name == anim_name:
		transition.emit(self, "Idle")
