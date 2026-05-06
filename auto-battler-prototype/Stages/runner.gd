extends Node
class_name Runner

@onready var char1 : PackedScene
@onready var char2 : PackedScene

@export var data1 : CharacterData
@export var loadout1 : Array[TechniqueData]
@export var p1SpawnPosition : Vector2

@export var data2 : CharacterData
@export var loadout2 : Array[TechniqueData]
@export var p2SpawnPosition : Vector2

@onready var nodeP1 : Character
@onready var nodeP2 : Character
@onready var dataTracker : DataTracker = %DataTracker
@onready var ui : Control = %UI
@onready var phanCam : PhantomCamera2D = %PhanCam
@export var camera : CustomCamera

signal broadcastFin(winner: String)

func _ready() -> void:
	initialize()

func initialize() -> void:
	char1 = load("res://Characters/generic/character.tscn")
	char2 = load("res://Characters/generic/character.tscn")
	if data1 != null and data2 != null:
		nodeP1 = char1.instantiate()
		nodeP2 = char2.instantiate()
		nodeP1.characterData = data1
		nodeP2.characterData = data2
		nodeP1.startFacingRight = true
		nodeP2.startFacingRight = false
		nodeP1.opponent = nodeP2
		nodeP2.opponent = nodeP1
		dataTracker.char1 = nodeP1
		dataTracker.char2 = nodeP2
		phanCam.follow_targets = [nodeP1, nodeP2]
		nodeP1.position = p1SpawnPosition
		nodeP2.position = p2SpawnPosition
		nodeP1.shakeCamera.connect(camera.add_trauma)
		nodeP2.shakeCamera.connect(camera.add_trauma)
		self.add_child(nodeP1)
		self.add_child(nodeP2)
		nodeP1.setup_loadout(loadout1)
		nodeP2.setup_loadout(loadout2)
		ui.P1 = nodeP1
		ui.P2 = nodeP2
		%LeftPopupSection.connect_to_character(nodeP1)
		%RightPopupSection.connect_to_character(nodeP2)
		ui.char_setup()

		nodeP1.broadcastLose.connect(broadcast_fin.bind("P2"))
		nodeP2.broadcastLose.connect(broadcast_fin.bind("P1"))

func reset() -> void:
	nodeP1.unload_loadout()
	loadout1.remove_at(-1)
	nodeP2.unload_loadout()
	loadout2.remove_at(-1)
	nodeP1.shakeCamera.disconnect(camera.add_trauma)
	nodeP2.shakeCamera.disconnect(camera.add_trauma)
	phanCam.follow_targets = []
	nodeP1.queue_free()
	nodeP2.queue_free()
	ui.clear()

func broadcast_fin(winner: String) -> void:
	var	finTimer: Timer = get_node("FinishTimer")

	# Make double sure at least one player's health is fully depleted
	if not (nodeP1.health and nodeP2.health):
		finTimer.start()
		# Engine.time_scale = 0.3
		# ^ would've been used for slowdown on fin but it breaks knockback physics
		await finTimer.timeout
		# Engine.time_scale = 1.0
		broadcastFin.emit(winner)
