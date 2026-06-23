extends Technique

func _ready() -> void:
	super()
	techniqueName = "PROJECTILE"
	animName = "projectile"

func execute_technique() -> void:
	print(characterName + " used %s", techniqueName)
