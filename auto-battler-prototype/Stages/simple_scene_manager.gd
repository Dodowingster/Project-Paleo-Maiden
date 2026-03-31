extends Node

func back_to_battle_setup(stage : Stage) -> void:
	var battleSetup : PackedScene = load("res://UI/Menus/BattleSetup.tscn")
	var battleSetupNode : BattleSetup = battleSetup.instantiate()
	var runner : Runner = stage.get_node("Runner")
	var p1CharData : CharacterData = runner.data1
	var p2CharData : CharacterData = runner.data2
	var p1LoadoutData : Array[TechniqueData] = runner.loadout1
	var p2LoadoutData : Array[TechniqueData] = runner.loadout2
	for child in runner.get_children():
		if child is Character:
			child.unload_loadout()
	get_tree().change_scene_to_node(battleSetupNode)
	await get_tree().scene_changed
	battleSetupNode.setupChar1.set_selection(p1CharData, p1LoadoutData)
	battleSetupNode.setupChar2.set_selection(p2CharData, p2LoadoutData)

func start_battle(setupChar1 : SetupChar, setupChar2 : SetupChar, stage : Stage) -> void:
	if setupChar1.selectedChar != null and setupChar2.selectedChar != null:
		var runner : Runner = stage.get_node("Runner")
		runner.data1 = setupChar1.selectedChar
		runner.data2 = setupChar2.selectedChar
		runner.loadout1 = setupChar1.selectedTech
		runner.loadout2 = setupChar2.selectedTech
	get_tree().change_scene_to_node(stage)
