extends PanelContainer
class_name CharDisplay

#@onready var selected_char_label : Label = %SelectedCharLabel
#@onready var hpValueLabel : Label = %HpValueLabel
#@onready var atkValueLabel : Label = %AtkValueLabel
#@onready var defValueLabel : Label = %DefValueLabel
#@onready var spdValueLabel : Label = %SpdValueLabel
#@onready var staValueLabel : Label = %StaValueLabel

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	if CurrentRunData.char_data:
		%SelectedCharLabel.text = CurrentRunData.char_data.character_name
		%HpValueLabel.text = str(CurrentRunData.char_data.current_hp) + "/" + str(CurrentRunData.char_data.max_hp)
		%AtkValueLabel.text = str(CurrentRunData.char_data.atk)
		%DefValueLabel.text = str(CurrentRunData.char_data.def)
		%SpdValueLabel.text = str(CurrentRunData.char_data.spd)
		%StaValueLabel.text = str(CurrentRunData.char_data.min_sta) + "-" + str(CurrentRunData.char_data.max_sta)
