extends VBoxContainer
class_name SetupChar

@onready var charList : Array[CharacterData]
@onready var techniqueList : Array[TechniqueData]

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
	charList.clear()
	techniqueList.clear()
	setup_character_list()
	setup_technique_list()
	setup_selection()

func setup_character_list() -> void:
	var dir = DirAccess.open("res://Characters")
	if dir:
		var charFolders = dir.get_directories()
		for charFolder in charFolders:
			dir.change_dir(charFolder)
			var charFiles = dir.get_files()
			if charFiles.size() > 0 and "_data.tres" in charFiles[0]:
				var charData : CharacterData = load(dir.get_current_dir() + "/" + charFiles[0])
				charList.append(charData)
			dir.change_dir("..")

func setup_technique_list() -> void:
	var dir = DirAccess.open("res://Characters")
	if dir:
		var charFolders = dir.get_directories()
		for charFolder in charFolders:
			dir.change_dir(charFolder + "/techniques")
			if dir:
				var techniqueFiles = dir.get_files()
				if techniqueFiles.size() > 0:
					for techniqueFile in techniqueFiles:
						if ".tres" in techniqueFile and "_baseatk.tres" not in techniqueFile:
							var techniqueData : TechniqueData = load(dir.get_current_dir() + "/" + techniqueFile)
							techniqueList.append(techniqueData) 
				dir.change_dir("../../")

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
			
