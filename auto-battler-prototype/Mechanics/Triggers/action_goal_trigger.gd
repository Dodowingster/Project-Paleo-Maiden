class_name ActionStockTrigger
extends Trigger

@onready var character : Character

func check_condition() -> bool:
	return character.current_action_stock > 0
