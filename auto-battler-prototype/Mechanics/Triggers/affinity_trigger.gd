extends Trigger
class_name AffinityTrigger

@onready var character : Character
@export var chanceMod : float

func check_condition() -> bool:
	var success_check = randi() % 100
	var chance = (character.affMgr.affLvl * chanceMod)/100.0
	return success_check <= chance
