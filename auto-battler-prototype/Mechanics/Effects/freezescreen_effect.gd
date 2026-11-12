class_name FreezeScreenEffect
extends Effect

@export var apply_frame : int
@export var revert_frame : int

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var freeze_screen : bool = false
@onready var prev_process_mode : ProcessMode
@onready var effect_done : bool = false

func execute_effect(delta: float) -> void:
	if not effect_done:
		if not freeze_screen:
			if time_elapsed > (apply_frame / 60.0):
				prev_process_mode = character.process_mode
				character.process_mode = Node.PROCESS_MODE_ALWAYS
				get_tree().paused = true
				freeze_screen = true
		else:
			if time_elapsed > (revert_frame / 60.0):
				get_tree().paused = false
				character.process_mode = prev_process_mode
				freeze_screen = false
				effect_done = true
		time_elapsed += delta

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	time_elapsed = 0
	freeze_screen = false
	effect_done = false
