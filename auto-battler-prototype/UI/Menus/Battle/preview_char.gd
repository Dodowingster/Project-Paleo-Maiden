extends VBoxContainer
class_name PreviewChar

@export var headerLabelText : String

@onready var selectedChar : CharacterData:
	set(value):
		%SelectedCharLabel.text = value.characterName
		selectedChar = value
		%Attributes.character_selected(value)
@onready var selectedLoadout : Array[TechniqueData] = [] :
	set(loadout):
		for technique in loadout:
			%SelectedTechList.add_item(technique.techniqueName)
			selectedLoadout = loadout

func _ready() -> void:
	%HeaderLabel.text = headerLabelText
