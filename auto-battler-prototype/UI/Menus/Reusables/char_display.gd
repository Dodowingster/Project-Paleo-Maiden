extends VBoxContainer
class_name CharDisplay

@onready var selectedCharLabel : Label = %SelectedCharLabel

func _ready() -> void:
	if CurrentRunData.char_data:
		selectedCharLabel.text = CurrentRunData.char_data.characterName
