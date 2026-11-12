class_name AffinityTrigger
extends Trigger

@export var chance_mod : float

@onready var character : Character

func check_condition() -> bool:
	var success_check = randf() * 100
	var chance = character.aff_mgr.aff_lvl * chance_mod
	return success_check <= chance
