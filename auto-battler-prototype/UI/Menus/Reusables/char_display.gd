extends PanelContainer
class_name CharDisplay

#@onready var selectedCharLabel : Label = %SelectedCharLabel
#@onready var hpValueLabel : Label = %HpValueLabel
#@onready var atkValueLabel : Label = %AtkValueLabel
#@onready var defValueLabel : Label = %DefValueLabel
#@onready var spdValueLabel : Label = %SpdValueLabel
#@onready var staValueLabel : Label = %StaValueLabel

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	if CurrentRunData.char_data:
		%SelectedCharLabel.text = CurrentRunData.char_data.characterName
		%HpValueLabel.text = str(CurrentRunData.char_data.currentHP) + "/" + str(CurrentRunData.char_data.maxHP)
		%AtkValueLabel.text = str(CurrentRunData.char_data.atk)
		%DefValueLabel.text = str(CurrentRunData.char_data.def)
		%SpdValueLabel.text = str(CurrentRunData.char_data.spd)
		%StaValueLabel.text = str(CurrentRunData.char_data.minSta) + "-" + str(CurrentRunData.char_data.maxSta)
