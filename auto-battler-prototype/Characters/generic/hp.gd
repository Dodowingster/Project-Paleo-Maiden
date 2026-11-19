extends Node

var max_hp : int
var current_hp : int
@export var stat_manager : StatManager

enum DamageMode {
	BLOCK,
	HIT
}

func _ready() -> void:
	max_hp = stat_manager.char_node.character_data.max_hp
	current_hp = max_hp

func increase_hp(val: int) -> void:
	current_hp += val if current_hp + val < max_hp else max_hp
	print(
		owner.character_name + "'s HP increased to " + current_hp + 
		"(max_hp: " + max_hp + ")"
	)

func decrease_hp(val: int) -> void:
	current_hp -= val if current_hp - val > 0 else 0
	print(
		owner.character_name + "'s HP increased to " + current_hp + 
		"(max_hp: " + max_hp + ")"
	)

func set_hp(val: int) -> void:
	current_hp = val
	if current_hp > max_hp:
		current_hp = max_hp
	elif current_hp < 0:
		current_hp = 0

	print(
		owner.character_name + "'s HP increased to " + current_hp + 
		"(max_hp: " + max_hp + ")"
	)

func reset_hp() -> void:
	current_hp = max_hp
	print(
		owner.character_name + "'s HP reset to " + current_hp + 
		"(max_hp: " + max_hp + ")"
	)

func take_damage(value : int, mode: DamageMode) -> int:
	var result_health = current_hp
	var actual_damage : int = value - stat_manager.def
	
	result_health -= actual_damage
	if result_health < 0:
		if mode == DamageMode.HIT:
			result_health = 0
		elif mode == DamageMode.BLOCK:
			result_health = 0
		else:
			push_error("Unknown DamageMode")

	return result_health