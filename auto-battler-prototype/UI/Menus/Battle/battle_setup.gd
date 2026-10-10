extends Control
class_name BattleSetup

@export var setupChar1 : SetupChar
@export var setupChar2 : SetupChar

func _ready() -> void:
	pass
	#Dialogic.start("testtimeline")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		_on_start_btn_pressed()

func _on_start_btn_pressed() -> void:
	var testStage : PackedScene = load("res://Stages/test_stage.tscn")
	var testStageNode : Stage = testStage.instantiate()
	SimpleSceneManager.start_battle(setupChar1, setupChar2, testStageNode)
