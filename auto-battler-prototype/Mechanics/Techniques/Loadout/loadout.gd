extends Node
class_name Loadout

@export var techniqueList : Array[Technique]
@export var character : Character
## Determines the jump in priority points from one slot to another.
@export var priorityInterval : int = 5
#@export var listSize : int

func _ready() -> void:
	var position : int = 0
	var arraySize : int = techniqueList.size()
	for technique in techniqueList:
		technique.setup_priority((arraySize - position) * priorityInterval)
		technique.setup_triggers(character)
		position += 1
