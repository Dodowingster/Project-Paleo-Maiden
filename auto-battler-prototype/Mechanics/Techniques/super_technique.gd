extends Technique

func _ready() -> void:
	super()
	technique_name = "SUPER"
	anim_name = "super"

func execute_technique() -> void:
	print(character_name + " used SUPER!")
