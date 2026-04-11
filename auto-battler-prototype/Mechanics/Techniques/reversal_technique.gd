extends Technique

func _ready() -> void:
	super()
	techniqueName = "Reversal"
	animName = "reversal"

func execute_technique() -> void:
	print(characterName + " used REVERSAL!")
