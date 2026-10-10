extends Control
class_name BattlePreview

@export var char1: CharacterData
@export var loadout1: Array[TechniqueData] = []
@export var char2: CharacterData
@export var loadout2: Array[TechniqueData] = []

func _ready() -> void:
	%PreviewChar.selectedChar = char1
	%PreviewChar.selectedLoadout = loadout1
	
	%PreviewChar2.selectedChar = char2
	%PreviewChar2.selectedLoadout = loadout2

func _on_start_btn_pressed() -> void:
	var testStage : PackedScene = load("res://Stages/test_stage.tscn")
	var testStageNode : Stage = testStage.instantiate()
	SimpleSceneManager.start_battle_2(char1, loadout1, char2, loadout2, testStageNode)
