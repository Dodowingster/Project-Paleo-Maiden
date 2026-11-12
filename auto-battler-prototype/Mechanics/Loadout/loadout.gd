class_name Loadout
extends Node

signal update_trigger_status(position: int, canExecute: bool)

@export var priority_per_position : int = 5

@onready var character : Character = owner
@onready var technique_to_execute : Technique

func setup_techniques() -> void:
	# Initialize techniques array
	var children = get_children()
	# gets all children, remember to filter by techniques
	var children_count : int = children.size()
	var count : int = 0

	for child in children:
		# We only want the techniques
		if child is Technique:
			child.setup_priority(priority_per_position * (children_count - count))
			child.setup_triggers_and_effects(character)
			child.execution_status_changed.connect(notify_ui)
			count += 1

func techniques_check() -> void:
	var chosen_technique : Technique = null
	var children = get_children()
	for child in children:
		if child is Technique:
			if child.trigger_check():
				if chosen_technique == null || chosen_technique.slot_priority < child.slot_priority:
					chosen_technique = child

	technique_to_execute = chosen_technique

func notify_ui(technique: Technique, execution_status: bool) -> void:
	update_trigger_status.emit(technique.get_index() + 1, execution_status)
