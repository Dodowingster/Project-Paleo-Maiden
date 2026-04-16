extends Trigger
class_name HitTrigger

@onready var character : Character
@onready var stateMachine: StateMachine

func check_condition() -> bool:
	return stateMachine.currentState == StateHitstun