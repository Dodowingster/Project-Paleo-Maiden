extends VBoxContainer
class_name AttributesList

@onready var hpEdit : LineEdit
@onready var atkEdit : LineEdit
@onready var defEdit : LineEdit
@onready var spdEdit : LineEdit
@onready var minStaEdit : LineEdit
@onready var maxStaEdit : LineEdit
@onready var minDistanceEdit : LineEdit
@onready var maxDistanceEdit : LineEdit

func _enter_tree() -> void:
	hpEdit = get_node("HPStat/StatEdit")
	atkEdit = get_node("AtkStat/StatEdit")
	defEdit = get_node("DefStat/StatEdit")
	spdEdit = get_node("SpdStat/StatEdit")
	minStaEdit = get_node("MinStaStat/StatEdit")
	maxStaEdit = get_node("MaxStaStat/StatEdit")
	minDistanceEdit = get_node("MinDistanceStat/StatEdit")
	maxDistanceEdit = get_node("MaxDistanceStat/StatEdit")

func character_selected(charData : CharacterData) -> void:
	hpEdit.text = str(charData.maxHP)
	atkEdit.text = str(charData.atk)
	defEdit.text = str(charData.def)
	spdEdit.text = str(charData.spd)
	minStaEdit.text = str(charData.minSta)
	maxStaEdit.text = str(charData.maxSta)
	minDistanceEdit.text = str(charData.minDistance)
	maxDistanceEdit.text = str(charData.maxDistance)

func update_character_data(charData : CharacterData) -> void:
	charData.maxHP = int(hpEdit.text)
	charData.atk = int(atkEdit.text)
	charData.def = int(defEdit.text)
	charData.spd = int(spdEdit.text)
	charData.minSta = int(minStaEdit.text)
	charData.maxSta = int(maxStaEdit.text)
	charData.minDistance = int(minDistanceEdit.text)
	charData.maxDistance = int(maxDistanceEdit.text)
