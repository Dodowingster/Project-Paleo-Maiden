extends PanelContainer
class_name TechniqueLoadout

@onready var techEntryScene : PackedScene = load("res://UI/Menus/Reusables/TechniqueEntry.tscn")
@export var starterList : Array[TechniqueData] = []

func _ready() -> void:
	if starterList.size() > 0:
		populate(starterList)
	else:
		populate(CurrentRunData.technique_loadout.get_list())
	CurrentRunData.technique_loadout.listChanged.connect(populate_from_current)

func populate(techList : Array[TechniqueData]) -> void:
	for child in %EntryList.get_children():
		child.queue_free()
	for tech in techList:
		var techEntryNode : TechniqueEntry = techEntryScene.instantiate()
		techEntryNode.technique = tech
		techEntryNode.entryType = TechniqueEntry.EntryType.LOADOUT
		%EntryList.add_child(techEntryNode)

func populate_from_current() -> void:
	for child in %EntryList.get_children():
		child.queue_free()
	for tech in CurrentRunData.technique_loadout.get_list():
		var techEntryNode : TechniqueEntry = techEntryScene.instantiate()
		techEntryNode.technique = tech
		techEntryNode.entryType = TechniqueEntry.EntryType.LOADOUT
		%EntryList.add_child(techEntryNode)
