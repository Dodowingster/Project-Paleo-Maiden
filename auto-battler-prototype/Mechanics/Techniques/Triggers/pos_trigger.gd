extends Trigger
class_name PositionTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.currentActionGoal > character.actionGoalTotal
