extends PanelContainer

@onready var techEntryScene : PackedScene = load("res://UI/Menus/Reusables/TechniqueEntry.tscn")
@export var exampleList : Array[TechniqueData]


func _ready() -> void:
	if exampleList.size() > 0:
		var techInv = TechniqueList.new()
		for item in exampleList:
			techInv.add(item)
		populate(techInv)
	else:
		populate(CurrentRunData.technique_inventory)
	CurrentRunData.technique_inventory.listChanged.connect(populate_from_current)
	CurrentRunData.technique_loadout.listChanged.connect(update_entries)

func populate(techniqueInv : TechniqueList) -> void:
	for child in %EntryList.get_children():
		child.queue_free()
	for tech in techniqueInv.get_list():
		var techEntryNode : TechniqueEntry = techEntryScene.instantiate()
		techEntryNode.technique = tech
		techEntryNode.entryType = TechniqueEntry.EntryType.INVENTORY
		%EntryList.add_child(techEntryNode)

func populate_from_current() -> void:
	for child in %EntryList.get_children():
		child.queue_free()
	for tech in CurrentRunData.get_list():
		var techEntryNode : TechniqueEntry = techEntryScene.instantiate()
		techEntryNode.technique = tech
		techEntryNode.entryType = TechniqueEntry.EntryType.INVENTORY
		%EntryList.add_child(techEntryNode)


func update_entries() -> void:
	for child in %EntryList.get_children():
		if child is TechniqueEntry:
			if child.technique in CurrentRunData.technique_loadout.get_list():
				child.set_active(false)
			else:
				child.set_active(true)
