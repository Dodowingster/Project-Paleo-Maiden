extends Technique

func _ready() -> void:
	super()
	technique_name = "PROJECTILE"
	anim_name = "projectile"

func execute_technique() -> void:
	print(character_name + " used %s", technique_name)
