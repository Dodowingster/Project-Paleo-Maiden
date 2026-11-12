extends Technique

func _ready() -> void:
	super()
	technique_name = "RUSH"
	anim_name = "rush"

func execute_technique() -> void:
	print(character_name + " used RUSH!")
