extends Node


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


func _ready() -> void:
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
		self.add_child(nodeP1)
		self.add_child(nodeP2)
		for technique_data in loadout1:
			var techniqueNode = technique_data.technique.instantiate()
			if techniqueNode is Technique:
				nodeP1.loadout.add_child(techniqueNode)
		nodeP1.loadout.setup_techniques()
		for technique_data in loadout2:
			var techniqueNode = technique_data.technique.instantiate()
			if techniqueNode is Technique:
				nodeP2.loadout.add_child(techniqueNode)
		nodeP2.loadout.setup_techniques()
		ui.P1 = nodeP1
		ui.P2 = nodeP2
		ui.char_setup()
