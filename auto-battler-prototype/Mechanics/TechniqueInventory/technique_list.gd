class_name TechniqueList
extends Node

signal list_changed()

@onready var _tech_list : Array[TechniqueData]

func get_list() -> Array[TechniqueData]:
	return _tech_list

func get_at_index(index : int) -> TechniqueData:
	if index >= 0 and index < _tech_list.size():
		return _tech_list[index]
	return null

func add(tech_data : TechniqueData):
	if tech_data not in _tech_list:
		_tech_list.append(tech_data)
		list_changed.emit()

func remove(tech_data : TechniqueData):
	var index : int = _tech_list.find(tech_data)
	if index != -1:
		_tech_list.remove_at(index)
		list_changed.emit()
