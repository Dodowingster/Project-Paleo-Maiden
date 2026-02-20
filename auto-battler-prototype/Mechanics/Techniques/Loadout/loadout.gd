extends Node
class_name Loadout

@onready var character : Character = owner

@export var priorityPerPosition : int = 5

func _ready() -> void:
	# Initialize techniques array
	var children = get_children()
	# gets all children, remember to filter by techniques
	var childrenCount : int = children.size()
	var count : int = 0

	for child in children:
		# We only want the techniques
		if child is Technique:
			child.setup_priority(priorityPerPosition * (childrenCount - count))
			child.setup_triggers(character)
			count += 1

func _process(_delta: float) -> void:
	var techniqueToExecute : Technique = null
	var children = get_children()
	var count : int = 0
	for child in children:
		if child is Technique:
			count += 1
			if child.trigger_check():
				child.canExecute.emit(count, true)
				if techniqueToExecute == null || techniqueToExecute.slotPriority < child.slotPriority:
					techniqueToExecute = child
			else:
				child.canExecute.emit(count, false)
			
	if techniqueToExecute != null:
		techniqueToExecute.execute_technique()
