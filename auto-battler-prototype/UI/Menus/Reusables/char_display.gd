extends VBoxContainer
class_name CharDisplay

@onready var selectedCharLabel : Label = %SelectedCharLabel
@onready var atkValueLabel : Label = %AtkValueLabel
@onready var defValueLabel : Label = %DefValueLabel
@onready var spdValueLabel : Label = %SpdValueLabel
@onready var minStaValueLabel : Label = %MinStaValueLabel
@onready var maxStaValueLabel : Label = %MaxStaValueLabel

func _ready() -> void:
	if CurrentRunData.char_data:
		selectedCharLabel.text = CurrentRunData.char_data.characterName
		atkValueLabel.text = str(CurrentRunData.char_data.atk)
		defValueLabel.text = str(CurrentRunData.char_data.def)
		spdValueLabel.text = str(CurrentRunData.char_data.spd)
		minStaValueLabel.text = str(CurrentRunData.char_data.minSta)
		maxStaValueLabel.text = str(CurrentRunData.char_data.maxSta)
