extends Node2D
class_name Stage

enum STAGEMODE {TEST, ENCOUNTER}

var always_running_nodes : Array[Node] = []
@onready var stage_mode : STAGEMODE = STAGEMODE.TEST

func _ready() -> void:
	StageManager.set_stage(self)
	%Runner.connect("broadcastFin", finish_game)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu") and not %FinishMenu.visible:
		if %PauseMenu.visible:
			_on_resume_btn_pressed()
		else:
			pause_game()
			%PauseMenu.visible = true

func _on_resume_btn_pressed() -> void:
	resume_game()
	%PauseMenu.visible = false

func _on_end_battle_btn_pressed() -> void:
	get_tree().paused = false
	VFXManager.despawn_all_vfx()
	if stage_mode == STAGEMODE.TEST:
		SimpleSceneManager.back_to_battle_setup(self)
	elif stage_mode == STAGEMODE.ENCOUNTER:
		update_current_run_data()
		unload_characters()
		if CurrentRunData.current_map_action == GlobalValues.MAPACTION.CAMP:
			SimpleSceneManager.setup_map()
		else:
			SimpleSceneManager.setup_map()
	else:
		SimpleSceneManager.back_to_battle_setup(self)

func update_current_run_data() -> void:
	var p1Char : Character = %Runner.get_node("Character")
	if p1Char != null:
		CurrentRunData.char_data.currentHP = p1Char.health
	#if %Runner.winningSide == "P1":
		#RewardsManager.reward_technique(p1Char.characterName)
	RewardsManager.reward_technique(p1Char.characterName)

func unload_characters() -> void:
	var p1LoadoutData : Array[TechniqueData] = %Runner.loadout1
	var p2LoadoutData : Array[TechniqueData] = %Runner.loadout2
	# remove base attacks from loadout
	p1LoadoutData.remove_at(-1)
	p2LoadoutData.remove_at(-1)
	for child in %Runner.get_children():
		if child is Character:
			child.unload_loadout()

func get_always_running_nodes() -> void:
	always_running_nodes = []
	for node in self.get_child(0).get_children():
		if node is Character and node.process_mode == PROCESS_MODE_ALWAYS:
			always_running_nodes.append(node)

func pause_game() -> void:
	get_always_running_nodes()
	if always_running_nodes.size() > 0:
		for node in always_running_nodes:
			node.process_mode = PROCESS_MODE_PAUSABLE
	get_tree().paused = true

func restart_game() -> void:
	always_running_nodes = []
	VFXManager.despawn_all_vfx()
	var finTimer : Timer = %Runner.get_node("FinishTimer")
	%DataTracker.reset()
	%Runner.reset()
	%Runner.initialize()
	finTimer.stop()
	StageManager.set_stage(self)
	get_tree().paused = false
	%PauseMenu.visible = false
	%FinishMenu.visible = false

func resume_game() -> void:
	if always_running_nodes.size() > 0:
		for node in always_running_nodes:
			node.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		get_tree().paused = false

func finish_game(winner: String) -> void:
	var finishLabel : Label = get_node("Runner/CanvasLayer/FinishMenu/PanelContainer/VBoxContainer/FinishLabel")

	if %Runner.nodeP1.health or %Runner.nodeP2.health:
		finishLabel.text = winner + " WIN"
	else:
		finishLabel.text = "DRAW"
	
	pause_game()
	%FinishMenu.visible = true
