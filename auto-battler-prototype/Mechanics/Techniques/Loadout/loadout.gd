extends Node
class_name Loadout

signal updateTriggerStatus(position: int, canExecute: bool)

@onready var character : Character = owner
@onready var techniqueToExecute : Technique

@export var priorityPerPosition : int = 5

func setup_techniques() -> void:
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
			child.executionStatusChanged.connect(notify_ui)
			count += 1

func techniques_check() -> void:
	var chosenTechnique : Technique = null
	var children = get_children()
	for child in children:
		if child is Technique:
			if child.trigger_check():
				if chosenTechnique == null || chosenTechnique.slotPriority < child.slotPriority:
					chosenTechnique = child
			
	techniqueToExecute = chosenTechnique

func notify_ui(technique: Technique, executionStatus: bool) -> void:
	updateTriggerStatus.emit(technique.get_index() + 1, executionStatus)
