extends Technique

func _ready() -> void:
	super()
	technique_name = "Reversal"
	anim_name = "reversal"

func execute_technique() -> void:
	print(character_name + " used REVERSAL!")
