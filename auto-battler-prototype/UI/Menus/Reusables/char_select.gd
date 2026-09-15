extends VBoxContainer
class_name CharacterSelect

signal characterSelected(charName : String)


@export var charList : Array[CharacterData]
@onready var charSelectList : ItemList = %CharList
@onready var selectedCharLabel : Label = %SelectedCharLabel
@onready var selectedChar : CharacterData


func _ready() -> void:
	for character in charList:
		charSelectList.add_item(character.characterName)


func _on_char_list_item_selected(index: int) -> void:
	selectedChar = charList[index]
	characterSelected.emit(selectedChar.characterName)
	selectedCharLabel.text = selectedChar.characterName
