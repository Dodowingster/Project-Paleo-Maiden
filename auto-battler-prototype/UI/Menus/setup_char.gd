extends VBoxContainer
class_name SetupChar

@export var charList : Array[CharacterData]
@export var techniqueList : Array[TechniqueData]

@export var headerLabelText : String
@onready var selectedChar : CharacterData
@onready var selectedTech : Array[TechniqueData]

@export var headerLabel : Label
@export var selectedCharLabel : Label
@export var charSelectList : ItemList
@export var techSelectList : ItemList
@export var selectedTechList : ItemList

func _ready() -> void:
	for character in charList:
		charSelectList.add_item(character.characterName)
	for tech in techniqueList:
		techSelectList.add_item(tech.techniqueName)
	headerLabel.text = headerLabelText


func _on_char_list_item_selected(index: int) -> void:
	selectedChar = charList[index]
	selectedCharLabel.text = selectedChar.characterName

func _on_technique_list_multi_selected(index: int, selected: bool) -> void:
	if selected:
		selectedTech.append(techniqueList[index])
		selectedTechList.add_item(techniqueList[index].techniqueName)
	else:
		selectedTechList.remove_item(selectedTech.find(techniqueList[index]))
		selectedTech.remove_at(selectedTech.find(techniqueList[index]))
		
	
