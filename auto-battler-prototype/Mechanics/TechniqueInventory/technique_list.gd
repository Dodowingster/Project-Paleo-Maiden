extends Node
class_name TechniqueList

signal listChanged()

@onready var _techList : Array[TechniqueData]

func get_list() -> Array[TechniqueData]:
	return _techList

func get_at_index(index : int) -> TechniqueData:
	if index >= 0 and index < _techList.size():
		return _techList[index]
	else:
		return null

func add(techData : TechniqueData):
	if techData not in _techList:
		_techList.append(techData)
		listChanged.emit()

func remove(techData : TechniqueData):
	var index : int = _techList.find(techData)
	if index != -1:
		_techList.remove_at(index)
		listChanged.emit()
