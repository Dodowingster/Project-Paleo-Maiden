extends Trigger
class_name CooldownAvailableTrigger

@onready var character : Character

func check_condition() -> bool:
	var condition_met : bool = false
	var techniques : Array = character.loadout.get_children()
	for technique in techniques:
		if technique is Technique:
			var trigsEffs = technique.get_children()
			var hasCooldown : bool = false
			for trigEff in trigsEffs:
				if trigEff is CooldownTrigger:
					if trigEff.currentTimer > 0:
						hasCooldown = true
						break
			if hasCooldown:
				condition_met = true
				break
	return condition_met
