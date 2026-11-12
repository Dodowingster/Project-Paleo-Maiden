extends Technique

func _ready() -> void:
	super()
	technique_name = "BASEATK"
	anim_name = "baseattack"

func execute_technique() -> void:
	print(character_name + " used %s", technique_name)
