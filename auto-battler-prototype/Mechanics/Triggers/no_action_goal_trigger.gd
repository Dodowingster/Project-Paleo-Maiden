extends Trigger
class_name NoActionGoalTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.currentActionGoal < character.actionGoalTotal
