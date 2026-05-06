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
		if affBonus is not EventAffinityBonus and affBonus.trigger_check():
			affBonus.execute_effects(delta)
			var character = self.get_parent()
			if character is Character:
				character.popupAffinity.emit(affBonus.affEffectName)

func check_event_bonuses() -> void:
	for affBonus in affBonuses:
		if affBonus is EventAffinityBonus and affBonus.trigger_check():
			affBonus.execute_effects(0)
			var character = self.get_parent()
			if character is Character:
				character.popupAffinity.emit(affBonus.affEffectName)
