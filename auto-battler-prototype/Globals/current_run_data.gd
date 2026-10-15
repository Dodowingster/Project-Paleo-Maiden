extends Node

@onready var char_data : CharacterData
@onready var technique_loadout : Array[TechniqueData]
@onready var technique_inventory : Array[TechniqueData]
@onready var current_node : MapNode
@onready var current_map_action : GlobalValues.MAPACTION
