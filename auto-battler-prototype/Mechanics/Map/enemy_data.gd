@tool
extends Node
class_name EnemyData

@export var baseCharacter : CharacterData :
	set(char_data):
		baseCharacter = char_data
		atk = char_data.atk
		def = char_data.def
		spd = char_data.spd
		minSta = char_data.minSta
		maxSta = char_data.maxSta
		maxHP = char_data.maxHP
		currentHP = char_data.maxHP
@export var atk : int = 5
@export var def : int = 5
@export var spd : int = 10
@export var minSta : int = 1
@export var maxSta : int = 10
@export var maxHP : int = 100

@export var currentHP : int = 0
@export var loadout : Array[TechniqueData] = []
