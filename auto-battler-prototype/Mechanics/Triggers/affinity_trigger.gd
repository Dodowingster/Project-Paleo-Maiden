extends Trigger
class_name AffinityTrigger

@onready var character : Character
@export var chanceMod : float

func check_condition() -> bool:
	var success_check = randf() * 100
	var chance = character.affMgr.affLvl * chanceMod
	return success_check <= chance
