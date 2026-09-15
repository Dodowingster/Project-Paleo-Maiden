extends Control
class_name BattleSetup

@export var charList : Array[CharacterData]
@export var techniqueList : Array[TechniqueData]

@export var setupChar1 : SetupChar
@export var setupChar2 : SetupChar

func _ready() -> void:
	#Dialogic.start("testtimeline")
	setupChar1.charList = charList
	setupChar1.techniqueList = techniqueList
	setupChar2.charList = charList
	setupChar2.techniqueList = techniqueList

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		_on_start_btn_pressed()

func _on_start_btn_pressed() -> void:
	var testStage : PackedScene = load("res://Stages/test_stage.tscn")
	var testStageNode : Stage = testStage.instantiate()
	SimpleSceneManager.start_battle(setupChar1, setupChar2, testStageNode)
