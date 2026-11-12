class_name CooldownAvailableTrigger
extends Trigger

@onready var character : Character

func check_condition() -> bool:
	var condition_met : bool = false
	var techniques : Array = character.loadout.get_children()
	for technique in techniques:
		if technique is Technique:
			var trigs_effs = technique.get_children()
			var has_cooldown : bool = false
			for trig_eff in trigs_effs:
				if trig_eff is CooldownTrigger:
					if trig_eff.current_timer > 0:
						has_cooldown = true
						break
			if has_cooldown:
				condition_met = true
				break
	return condition_met
