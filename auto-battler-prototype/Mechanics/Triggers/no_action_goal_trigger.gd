class_name NoActionGoalTrigger
extends Trigger

@onready var character : Character

func check_condition() -> bool:
	return character.current_action_goal < character.action_goal_total
