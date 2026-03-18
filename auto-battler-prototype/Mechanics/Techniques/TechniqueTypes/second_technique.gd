extends Technique

func _ready() -> void:
	super()
	techniqueName = "SECOND"

func execute_technique() -> void:
	print(characterName + " used SECOND!")
