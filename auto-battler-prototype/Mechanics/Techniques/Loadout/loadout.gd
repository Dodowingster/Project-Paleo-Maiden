extends Node
class_name Loadout

@onready var character : Character = owner

@export var priorityPerPosition : int = 5

func _ready() -> void:
	# Initialize techniques array
	var children = get_children()
	var count : int = 0

	for child in children:
		# We only want the techniques
		if child is Technique:
			count += 1
			child.setup_priority(priorityPerPosition * count)
			child.setup_triggers(character)

func _process(_delta: float) -> void:
	var techniqueToExecute : Technique = null
	var children = get_children()
	for child in children:
		if child is Technique:
			if child.trigger_check():
				if techniqueToExecute == null || techniqueToExecute.slotPriority < child.slotPriority:
					techniqueToExecute = child
	if techniqueToExecute != null:
		techniqueToExecute.execute_technique()
