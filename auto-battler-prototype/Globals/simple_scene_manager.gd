extends Node

# to be removed eventually
func back_to_battle_setup(stage : Stage) -> void:
	var battle_setup : PackedScene = load("res://UI/Menus/Battle/BattleSetup.tscn")
	var battle_setup_node : BattleSetup = battle_setup.instantiate()
	if stage != null:
		var runner : Runner = stage.get_node("Runner")
		var p1_char_data : CharacterData = runner.data1
		var p2_char_data : CharacterData = runner.data2
		var p1_loadout_data : Array[TechniqueData] = runner.loadout1
		var p2_loadout_data : Array[TechniqueData] = runner.loadout2
		# remove base attacks from loadout
		p1_loadout_data.remove_at(-1)
		p2_loadout_data.remove_at(-1)
		for child in runner.get_children():
			if child is Character:
				child.unload_loadout()
		get_tree().change_scene_to_node(battle_setup_node)
		await get_tree().scene_changed
		battle_setup_node.setup_char1.set_selection(p1_char_data, p1_loadout_data)
		battle_setup_node.setup_char2.set_selection(p2_char_data, p2_loadout_data)
	else:
		get_tree().change_scene_to_node(battle_setup_node)
		await get_tree().scene_changed

func setup_map() -> void:
	var map_path : PackedScene = load("res://Stages/Board/test_map.tscn")
	var map_node : Map = map_path.instantiate()
	map_node.setup()
	get_tree().change_scene_to_node(map_node)
	await get_tree().scene_changed

# to be removed eventually
func start_battle(setup_char1 : SetupChar, setup_char2 : SetupChar, stage : Stage) -> void:
	if setup_char1.selected_char != null and setup_char2.selected_char != null:
		setup_char1.attributes_list.update_character_data(setup_char1.selected_char)
		setup_char2.attributes_list.update_character_data(setup_char2.selected_char)
		var runner : Runner = stage.get_node("Runner")
		runner.data1 = setup_char1.selected_char
		runner.data2 = setup_char2.selected_char
		runner.loadout1 = setup_char1.selected_tech
		runner.loadout2 = setup_char2.selected_tech
		# default hp for characters is 0, so we set their current hp to max hp before starting
		runner.data1.current_hp = runner.data1.max_hp
		runner.data2.current_hp = runner.data2.max_hp
	get_tree().change_scene_to_node(stage)

func start_battle_2(character1: CharacterData, loadout1: Array[TechniqueData], \
character2: CharacterData, loadout2: Array[TechniqueData], stage: Stage, \
stage_mode: Stage.StageMode) -> void:
	var runner : Runner = stage.get_node("Runner")
	runner.data1 = character1
	runner.data2 = character2
	runner.loadout1 = loadout1
	runner.loadout2 = loadout2
	get_tree().change_scene_to_node(stage)
	await get_tree().scene_changed
	stage.stage_mode = stage_mode
