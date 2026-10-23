extends HBoxContainer
class_name TechniqueEntry

enum EntryType {INVENTORY, LOADOUT}

@export var entryType : EntryType
@export var technique : TechniqueData

func _ready() -> void:
	if entryType == EntryType.INVENTORY:
		%Action.text = "Equip"
		if technique in CurrentRunData.technique_loadout.get_list():
			%Action.disabled = true
	elif entryType == EntryType.LOADOUT:
		%Action.text = "Remove"
	else:
		%Action.text = "Remove"
	if technique:
		%TechniqueName.text = technique.techniqueName

func set_active(active : bool):
	%Action.disabled = !active

func _remove_from_loadout() -> bool:
	if technique in CurrentRunData.technique_loadout.get_list():
		CurrentRunData.technique_loadout.remove(technique)
		return true
	else:
		return false


func _add_to_loadout() -> bool:
	if technique not in CurrentRunData.technique_loadout.get_list() and technique in CurrentRunData.technique_inventory.get_list():
		CurrentRunData.technique_loadout.add(technique)
		return true
	else:
		return false


func _on_action_pressed() -> void:
	if entryType == EntryType.INVENTORY:
		if _add_to_loadout():
			%Action.disabled = true
	else:
		if _remove_from_loadout():
			self.queue_free()
