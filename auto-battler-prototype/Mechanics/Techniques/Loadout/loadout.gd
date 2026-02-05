extends Node
class_name Loadout

@export var techniqueList : Array[Technique]
@export var character : Character
#@export var listSize : int

func _ready() -> void:
	for technique in techniqueList:
		technique.setup_triggers(character)
