extends Control

@onready var continueBtn : Button = %ContinueBtn
@onready var mainOptions : VBoxContainer = %MainOptions
@onready var newGameOptions : VBoxContainer = %NewGameOptions
@onready var charSelect : CharacterSelect = %CharSelect
@onready var testMapNodePath : String = "res://Stages/Board/test_map.tscn"

func _ready() -> void:
	mainOptions.visible = true
	continueBtn.visible = false
	newGameOptions.visible = false


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_new_game_btn_pressed() -> void:
	mainOptions.visible = false
	newGameOptions.visible = true


func _on_char_select_back_btn_pressed() -> void:
	mainOptions.visible = true
	newGameOptions.visible = false


func _on_start_run_btn_pressed() -> void:
	CurrentRunData.char_data = charSelect.selectedChar
	var testMapScene : PackedScene = load(testMapNodePath)
	var testMapNode : Node2D = testMapScene.instantiate()
	get_tree().change_scene_to_node(testMapNode)
