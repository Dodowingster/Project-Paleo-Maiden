class_name StatManager
extends Node

## Base stat to calculate attack damage from
@onready var atk: int
## Base stat to calculate damage taken
@onready var def: int
## Determines general move speed (in pixels I think?)
@onready var spd: int
## Minimum stamina roll to add to action goal
@onready var min_sta: int
## Maximum stamina roll to add to action goal
@onready var max_sta: int
## Maximum HP
@onready var max_hp: int
## Current HP
var cur_hp: int

## Modifies base forward movement speed
@onready var forward_spd_mult: float
## Modifies base backward movement speed
@onready var backward_spd_mult: float
## Modifies dash forward movement speed
@onready var forward_dash_spd_mult: float
## Modifies dash backward movement speed
@onready var backward_dash_spd_mult: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_stats()

## Initialises stats for the characters. Only works when the parent node is of type Character.
func setup_stats() -> void:
	var char_node: Character = get_parent()
	
	# Malleable stats
	atk = char_node.character_data.atk
	def = char_node.character_data.def
	spd = char_node.character_data.spd
	min_sta = char_node.character_data.min_sta
	max_sta = char_node.character_data.max_sta
	max_hp = char_node.character_data.max_hp
	cur_hp = max_hp

	# Static stats
	forward_spd_mult = char_node.character_data.forward_spd_mult
	backward_spd_mult = char_node.character_data.backward_spd_mult
	forward_dash_spd_mult = char_node.character_data.forward_dash_spd_mult
	backward_dash_spd_mult = char_node.character_data.backward_dash_spd_mult
