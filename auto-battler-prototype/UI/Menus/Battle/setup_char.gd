class_name SetupChar
extends VBoxContainer

@export var header_label_text : String
@export var header_label : Label
@export var selected_char_label : Label
@export var char_select_list : ItemList
@export var tech_overall_list : VBoxContainer
@export var tech_select_list : ItemList
@export var selected_tech_list : ItemList
@export var attributes_list : AttributesList

@onready var char_list : Array[CharacterData]
@onready var technique_list : Array[TechniqueData]

@onready var selected_char : CharacterData
@onready var selected_tech : Array[TechniqueData]

func _ready() -> void:
	char_list.clear()
	technique_list.clear()
	setup_character_list()
	setup_technique_list("")
	setup_selection()

func setup_character_list() -> void:
	var dir = DirAccess.open("res://Characters")
	if dir:
		var char_folders = dir.get_directories()
		for char_folder in char_folders:
			dir.change_dir(char_folder)
			var char_files = dir.get_files()
			if char_files.size() > 0 and "_data.tres" in char_files[0]:
				var charData : CharacterData = load(dir.get_current_dir() + "/" + char_files[0])
				char_list.append(charData)
			dir.change_dir("..")

func setup_technique_list(char_filter : String) -> void:
	var dir = DirAccess.open("res://Characters")
	if dir:
		var char_folders = dir.get_directories()
		for char_folder in char_folders:
			if char_filter == "" or char_filter == char_folder:
				dir.change_dir(char_folder + "/techniques")
				if dir:
					var technique_files = dir.get_files()
					if technique_files.size() > 0:
						for technique_file in technique_files:
							if ".tres" in technique_file and "_baseatk.tres" not in technique_file:
								var technique_data : TechniqueData = load(dir.get_current_dir() + "/" + technique_file)
								technique_list.append(technique_data)
					dir.change_dir("../../")

func setup_selection() -> void:
	for character in char_list:
		char_select_list.add_item(character.character_name)
	for tech in technique_list:
		tech_select_list.add_item(tech.technique_name)
	header_label.text = header_label_text

func set_selection(prev_char : CharacterData, prev_tech : Array[TechniqueData]) -> void:
	char_select_list.deselect_all()
	tech_select_list.deselect_all()
	var og_index : int = find_original_index(prev_char)
	char_select_list.select(og_index)
	_on_char_list_item_selected(og_index)
	attributes_list.character_selected(prev_char) # override original data after 1st battle
	for tech in prev_tech:
		tech_select_list.select(technique_list.find(tech), false)
		_on_technique_list_multi_selected(technique_list.find(tech), true)

func _on_char_list_item_selected(index: int) -> void:
	selected_char = char_list[index].duplicate_deep()
	selected_char_label.text = selected_char.character_name
	attributes_list.character_selected(selected_char)
	tech_select_list.deselect_all()
	tech_select_list.clear()
	selected_tech_list.clear()
	selected_tech.clear()
	technique_list.clear()
	setup_technique_list(selected_char.character_name.to_lower())
	for tech in technique_list:
		tech_select_list.add_item(tech.technique_name)

func _on_technique_list_multi_selected(index: int, selected: bool) -> void:
	if selected:
		selected_tech.append(technique_list[index])
		selected_tech_list.add_item(technique_list[index].technique_name)
	else:
		selected_tech_list.remove_item(selected_tech.find(technique_list[index]))
		selected_tech.remove_at(selected_tech.find(technique_list[index]))

func find_original_index(copied_data : CharacterData) -> int:
	var found_value : int = -1
	for data in char_list:
		if data is CharacterData and data.character_name == copied_data.character_name:
			found_value = char_list.find(data)

	return found_value
