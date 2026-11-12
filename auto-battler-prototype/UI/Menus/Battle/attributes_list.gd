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
@onready var fwdSpdMultEdit : LineEdit
@onready var bkwdSpdMultEdit : LineEdit

func _enter_tree() -> void:
	hpEdit = get_node("HPStat/StatEdit")
	atkEdit = get_node("AtkStat/StatEdit")
	defEdit = get_node("DefStat/StatEdit")
	spdEdit = get_node("SpdStat/StatEdit")
	minStaEdit = get_node("MinStaStat/StatEdit")
	maxStaEdit = get_node("MaxStaStat/StatEdit")
	minDistanceEdit = get_node("MinDistanceStat/StatEdit")
	maxDistanceEdit = get_node("MaxDistanceStat/StatEdit")
	fwdSpdMultEdit = get_node("FwdSpdMultStat/StatEdit")
	bkwdSpdMultEdit = get_node("BkwdSpdMultStat/StatEdit")

func character_selected(charData : CharacterData) -> void:
	hpEdit.text = str(charData.max_hp)
	atkEdit.text = str(charData.atk)
	defEdit.text = str(charData.def)
	spdEdit.text = str(charData.spd)
	minStaEdit.text = str(charData.min_sta)
	maxStaEdit.text = str(charData.max_sta)
	minDistanceEdit.text = str(charData.min_distance)
	maxDistanceEdit.text = str(charData.max_distance)
	fwdSpdMultEdit.text = str(charData.forward_spd_mult)
	bkwdSpdMultEdit.text = str(charData.backward_spd_mult)

func update_character_data(charData : CharacterData) -> void:
	charData.max_hp = int(hpEdit.text)
	charData.atk = int(atkEdit.text)
	charData.def = int(defEdit.text)
	charData.spd = int(spdEdit.text)
	charData.min_sta = int(minStaEdit.text)
	charData.max_sta = int(maxStaEdit.text)
	charData.min_distance = int(minDistanceEdit.text)
	charData.max_distance = int(maxDistanceEdit.text)
	charData.forward_spd_mult = float(fwdSpdMultEdit.text)
	charData.backward_spd_mult = float(bkwdSpdMultEdit.text)
