extends Node
class_name Loadout

var techniqueList : Array[Technique]

@onready var character : Character = owner

func _ready() -> void:
	# Initialize techniques array
	var children = get_children()

	for child in children:
		# We only want the techniques
		if child is Technique:
			child.setup_triggers(character)
			techniqueList.append(child)
