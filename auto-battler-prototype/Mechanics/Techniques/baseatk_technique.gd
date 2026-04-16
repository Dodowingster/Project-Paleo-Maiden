extends Technique

func _ready() -> void:
	super()
	techniqueName = "BASEATK"
	animName = "baseattack"

func execute_technique() -> void:
	print(characterName + " used %s", techniqueName)
