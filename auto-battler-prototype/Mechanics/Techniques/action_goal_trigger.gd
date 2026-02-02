extends Trigger
class_name ActionGoalTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.currentActionGoal > character.actionGoalTotal
