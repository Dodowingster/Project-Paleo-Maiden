extends Node2D
class_name Stage

var always_running_nodes : Array[Node] = []

func _ready() -> void:
	StageManager.set_stage(self)

	var runner = get_node("Runner")
	runner.connect("broadcastFin", finish_game)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu") and not %FinishMenu.visible:
		if %PauseMenu.visible:
			_on_resume_btn_pressed()
		else:
			pause_game()
			%PauseMenu.resumeBtn.grab_focus.call_deferred()
			%PauseMenu.visible = true

func _on_resume_btn_pressed() -> void:
	resume_game()
	%PauseMenu.visible = false

func _on_end_battle_btn_pressed() -> void:
	get_tree().paused = false
	SimpleSceneManager.back_to_battle_setup(self)

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
	var runner : Runner = get_node("Runner")
	%DataTracker.reset()
	runner.reset()
	runner.initialize()
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
	var finishLabel : Label = get_node("Runner/CanvasLayer/FinishMenu/PanelContainer/VBoxContainer/FinLabel")

	pause_game()
	finishLabel.text = winner + " WIN"
	%FinishMenu.visible = true
	%FinishMenu.rematchBtn.grab_focus()