class_name ResetCooldownEffect
extends Effect

@onready var character : Character
@onready var triggered : bool = false

func choose_valid_target() -> Technique:
	var valid_targets : Array[Technique]
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
				valid_targets.append(technique)
	var random_index : int = randi() % valid_targets.size()
	return valid_targets[random_index]

func reset_technique_cooldown(technique : Technique) -> void:
	var trigs_effs = technique.get_children()
	for trig_eff in trigs_effs:
		if trig_eff is CooldownTrigger:
			trig_eff.force_ready()
			break

func execute_effect(_delta: float) -> void:
	if not triggered:
		reset_technique_cooldown(choose_valid_target())
		triggered = true

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	triggered = false
