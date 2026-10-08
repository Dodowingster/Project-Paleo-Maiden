extends VBoxContainer
class_name CharDisplay

@onready var selectedCharLabel : Label = %SelectedCharLabel
@onready var hpValueLabel : Label = %HpValueLabel
@onready var atkValueLabel : Label = %AtkValueLabel
@onready var defValueLabel : Label = %DefValueLabel
@onready var spdValueLabel : Label = %SpdValueLabel
@onready var staValueLabel : Label = %StaValueLabel

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	if CurrentRunData.char_data:
		selectedCharLabel.text = CurrentRunData.char_data.characterName
		hpValueLabel.text = str(CurrentRunData.current_hp) + "/" + str(CurrentRunData.char_data.maxHP)
		atkValueLabel.text = str(CurrentRunData.char_data.atk)
		defValueLabel.text = str(CurrentRunData.char_data.def)
		spdValueLabel.text = str(CurrentRunData.char_data.spd)
		staValueLabel.text = str(CurrentRunData.char_data.minSta) + "-" + str(CurrentRunData.char_data.maxSta)
