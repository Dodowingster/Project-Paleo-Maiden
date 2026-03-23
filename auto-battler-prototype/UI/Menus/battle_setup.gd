extends Control

@export var charList : Array[CharacterData]
@export var techniqueList : Array[TechniqueData]

@export var setupChar1 : SetupChar
@export var setupChar2 : SetupChar

func _ready() -> void:
	setupChar1.charList = charList
	setupChar1.techniqueList = techniqueList
	setupChar2.charList = charList
	setupChar2.techniqueList = techniqueList
			
func _on_start_btn_pressed() -> void:
	var testStage : PackedScene = load("res://Stages/test_stage.tscn")
	var testStageNode : Stage = testStage.instantiate()
	if setupChar1.selectedChar != null and setupChar2.selectedChar != null:
		var runner : Runner = testStageNode.get_node("Runner")
		runner.data1 = setupChar1.selectedChar
		runner.data2 = setupChar2.selectedChar
		runner.loadout1 = setupChar1.selectedTech
		runner.loadout2 = setupChar2.selectedTech
	get_tree().change_scene_to_node(testStageNode)
