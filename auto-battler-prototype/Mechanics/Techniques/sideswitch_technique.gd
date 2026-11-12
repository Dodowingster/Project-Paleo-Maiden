extends Technique

func _ready() -> void:
	super()
	technique_name = "SIDESWITCH"
	anim_name = "sideswitch"

func execute_technique() -> void:
	print(character_name + " used SIDESWITCH!")
