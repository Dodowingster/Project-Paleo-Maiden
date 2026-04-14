extends Node
class_name AffinityManager

#@export var affEXP : int = 0
@export var affLvl : int = 0
@onready var affBonuses : Array[AffinityBonus]

func setup_affinity_bonuses(scenes : Array[PackedScene]) -> void:
	affBonuses = []
	for scene in scenes:
		var sceneNode = scene.instantiate()
		if sceneNode is AffinityBonus:
			self.add_child(sceneNode)
			affBonuses.append(sceneNode)
			sceneNode.setup_triggers_and_effects(self.get_parent())
		else:
			sceneNode.queue_free()

func _process(delta: float) -> void:
	for affBonus in affBonuses:
		if affBonus.trigger_check():
			affBonus.execute_effects(delta)
			print("AFFINITY BONUS TRIGGERED")
