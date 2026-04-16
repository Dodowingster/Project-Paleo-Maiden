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
@export var techOverallList : VBoxContainer
@export var techSelectList : ItemList
@export var selectedTechList : ItemList
@export var attributesList : AttributesList

func _ready() -> void:
	setup_selection()

func setup_selection() -> void:
	for character in charList:
		charSelectList.add_item(character.characterName)
	for tech in techniqueList:
		techSelectList.add_item(tech.techniqueName)
	headerLabel.text = headerLabelText

func set_selection(prevChar : CharacterData, prevTech : Array[TechniqueData]) -> void:
	charSelectList.deselect_all()
	techSelectList.deselect_all()
	var ogIndex : int = find_original_index(prevChar)
	charSelectList.select(ogIndex)
	_on_char_list_item_selected(ogIndex)
	attributesList.character_selected(prevChar) # override original data after 1st battle
	for tech in prevTech:
		techSelectList.select(techniqueList.find(tech), false)
		_on_technique_list_multi_selected(techniqueList.find(tech), true)

func _on_char_list_item_selected(index: int) -> void:
	selectedChar = charList[index].duplicate_deep()
	selectedCharLabel.text = selectedChar.characterName
	attributesList.character_selected(selectedChar)

func _on_technique_list_multi_selected(index: int, selected: bool) -> void:
	if selected:
		selectedTech.append(techniqueList[index])
		selectedTechList.add_item(techniqueList[index].techniqueName)
	else:
		selectedTechList.remove_item(selectedTech.find(techniqueList[index]))
		selectedTech.remove_at(selectedTech.find(techniqueList[index]))

func find_original_index(copied_data : CharacterData) -> int:
	var foundValue : int = -1
	for data in charList:
		if data is CharacterData and data.characterName == copied_data.characterName:
			foundValue = charList.find(data)
	
	return foundValue
			
