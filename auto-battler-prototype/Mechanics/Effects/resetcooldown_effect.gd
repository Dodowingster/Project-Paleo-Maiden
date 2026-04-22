extends Effect
class_name ResetCooldownEffect

@onready var character : Character
@onready var triggered : bool = false

func choose_valid_target() -> Technique:
	var validTargets : Array[Technique]
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
				validTargets.append(technique)
	var randomIndex : int = randi() % validTargets.size()
	return validTargets[randomIndex]

func reset_technique_cooldown(technique : Technique) -> void:
	var trigsEffs = technique.get_children()
	for trigEff in trigsEffs:
		if trigEff is CooldownTrigger:
			trigEff.force_ready()
			break

func execute_effect(delta: float) -> void:
	if not triggered:
		reset_technique_cooldown(choose_valid_target())
		triggered = true

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	triggered = false
