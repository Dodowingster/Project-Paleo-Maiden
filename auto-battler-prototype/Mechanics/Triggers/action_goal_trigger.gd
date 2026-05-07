extends Trigger
class_name ActionStockTrigger

@onready var character : Character

func check_condition() -> bool:
	return character.currentActionStock > 0
