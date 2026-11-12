@tool
class_name EnemyData
extends Node

@export var base_character : CharacterData :
	set(char_data):
		base_character = char_data
		atk = char_data.atk
		def = char_data.def
		spd = char_data.spd
		min_sta = char_data.min_sta
		max_sta = char_data.max_sta
		max_hp = char_data.max_hp
		current_hp = char_data.max_hp
@export var atk : int = 5
@export var def : int = 5
@export var spd : int = 10
@export var min_sta : int = 1
@export var max_sta : int = 10
@export var max_hp : int = 100

@export var current_hp : int = 0
@export var loadout : Array[TechniqueData] = []
