class_name BattleSetup
extends Control

@export var setup_char1 : SetupChar
@export var setup_char2 : SetupChar

func _ready() -> void:
	pass
	#Dialogic.start("testtimeline")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		_on_start_btn_pressed()

func _on_start_btn_pressed() -> void:
	var test_stage : PackedScene = load("res://Stages/test_stage.tscn")
	var test_stage_node : Stage = test_stage.instantiate()
	SimpleSceneManager.start_battle(setup_char1, setup_char2, test_stage_node)
