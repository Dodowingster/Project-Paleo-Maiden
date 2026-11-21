class_name StatCompHp
extends Node

@onready var max_hp : int
@onready var current_hp : int
@export var stat_manager : StatManager
@export var def_stat : Node

enum DamageMode {
	BLOCK,
	HIT
}

func setup_component(char_node: Character) -> StatCompHp:
	max_hp = char_node.character_data.max_hp
	# current_hp = char_node.character_data.current_hp
	current_hp = max_hp
	print(
		owner.character_name + "'s HP set to " + str(current_hp) + 
		" (max_hp: " + str(max_hp) + ")"
	)

	return self

func increase_hp(val: int) -> void:
	current_hp += val if current_hp + val < max_hp else max_hp
	print(
		owner.character_name + "'s HP increased to " + current_hp + 
		" (max_hp: " + max_hp + ")"
	)

func take_damage(value: int, mode: DamageMode) -> void:
	var actual_damage : int = value - stat_manager.def
	
	current_hp -= actual_damage
	if current_hp < 0:
		if mode == DamageMode.HIT:
			current_hp = 0
		elif mode == DamageMode.BLOCK:
			current_hp = 0
		else:
			push_error("Unknown DamageMode")

	print(
		owner.character_name + "'s HP decreased to " + str(current_hp) + 
		" (max_hp: " + str(max_hp) + ")"
	)

func set_hp(val: int) -> void:
	current_hp = val
	if current_hp > max_hp:
		current_hp = max_hp
	elif current_hp < 0:
		current_hp = 0

	print(
		owner.character_name + "'s HP set to " + str(current_hp) + 
		" (max_hp: " + str(max_hp) + ")"
	)

func reset_hp() -> void:
	current_hp = max_hp
	print(
		owner.character_name + "'s HP reset to " + str(current_hp) + 
		" (max_hp: " + str(max_hp) + ")"
	)
