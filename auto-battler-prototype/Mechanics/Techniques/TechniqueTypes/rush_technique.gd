extends Technique

func _ready() -> void:
    super()
    techniqueName = "RUSH"

func execute_technique() -> void:
    print(characterName + " used RUSH!")