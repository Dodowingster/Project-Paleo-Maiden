extends Technique

func _ready() -> void:
	super()
	techniqueName = "SUPER"
	animName = "super"

func execute_technique() -> void:
	print(characterName + " used SUPER!")
