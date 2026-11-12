extends VBoxContainer
class_name PreviewChar

@export var header_label_text : String

@onready var selected_char : CharacterData:
	set(value):
		%SelectedCharLabel.text = value.character_name
		selected_char = value
		%Attributes.character_selected(value)
@onready var selectedLoadout : Array[TechniqueData] = [] :
	set(loadout):
		for technique in loadout:
			%SelectedTechList.add_item(technique.technique_name)
			selectedLoadout = loadout

func _ready() -> void:
	%HeaderLabel.text = header_label_text
