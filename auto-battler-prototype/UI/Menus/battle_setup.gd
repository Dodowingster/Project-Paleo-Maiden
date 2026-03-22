extends Control


func _on_start_btn_pressed() -> void:
	var testStage : PackedScene = load("res://Stages/test_stage.tscn")
	var testStageNode : Node2D = testStage.instantiate()
	get_tree().change_scene_to_node(testStageNode)
