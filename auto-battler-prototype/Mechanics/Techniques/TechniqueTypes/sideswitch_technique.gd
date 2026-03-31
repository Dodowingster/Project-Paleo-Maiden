extends Technique

func _ready() -> void:
	super()
	techniqueName = "SIDESWITCH"
	animName = "sideswitch"

func execute_technique() -> void:
	print(characterName + " used SIDESWITCH!")
