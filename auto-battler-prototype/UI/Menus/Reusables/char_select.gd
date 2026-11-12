extends VBoxContainer
class_name CharacterSelect

signal characterSelected(charName : String)


@export var char_list : Array[CharacterData]
@onready var char_select_list : ItemList = %CharList
@onready var selected_char_label : Label = %SelectedCharLabel
@onready var selected_char : CharacterData


func _ready() -> void:
	for character in char_list:
		char_select_list.add_item(character.character_name)


func _on_char_list_item_selected(index: int) -> void:
	selected_char = char_list[index]
	characterSelected.emit(selected_char.character_name)
	selected_char_label.text = selected_char.character_name
