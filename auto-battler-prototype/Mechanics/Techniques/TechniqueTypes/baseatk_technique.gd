extends Technique

func _ready() -> void:
	super()
	techniqueName = "BASEATK"
	animName = "baseatk"

func execute_technique() -> void:
	print(characterName + " used %s", techniqueName)
