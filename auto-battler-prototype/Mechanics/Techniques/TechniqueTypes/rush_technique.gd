extends Technique

func _ready() -> void:
	super()
	techniqueName = "RUSH"
	animName = "rush"

func execute_technique() -> void:
	print(characterName + " used RUSH!")
