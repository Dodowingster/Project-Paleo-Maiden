class_name AffinityManager
extends Node

#@export var affEXP : int = 0
@export var aff_lvl : int = 0
@onready var aff_bonuses : Array[AffinityBonus]

func setup_affinity_bonuses(scenes : Array[PackedScene]) -> void:
	aff_bonuses = []
	for scene in scenes:
		var scene_node = scene.instantiate()
		if scene_node is AffinityBonus:
			self.add_child(scene_node)
			aff_bonuses.append(scene_node)
			scene_node.setup_triggers_and_effects(self.get_parent())
		else:
			scene_node.queue_free()

func _process(delta: float) -> void:
	for aff_bonus in aff_bonuses:
		if aff_bonus is not EventAffinityBonus and aff_bonus.trigger_check():
			aff_bonus.execute_effects(delta)
			var character = self.get_parent()
			if character is Character:
				character.popup_affinity.emit(aff_bonus.aff_effect_name)

func check_event_bonuses() -> void:
	for aff_bonus in aff_bonuses:
		if aff_bonus is EventAffinityBonus and aff_bonus.trigger_check():
			aff_bonus.execute_effects(0)
			var character = self.get_parent()
			if character is Character:
				character.popup_affinity.emit(aff_bonus.aff_effect_name)
