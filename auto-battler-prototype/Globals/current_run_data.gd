extends Node

@onready var char_data : CharacterData
@onready var technique_loadout : TechniqueList = TechniqueList.new()
@onready var technique_inventory : TechniqueList = TechniqueList.new()
@onready var current_node_id : int = -1
@onready var current_map_action : GlobalValues.MAPACTION
