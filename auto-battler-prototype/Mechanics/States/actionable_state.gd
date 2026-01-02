extends State
class_name ActionableState

func update(_delta: float):
	var decision : String = ""
	var chosenStrategy: GlobalValues.STRATEGY = owner.strategy

	if chosenStrategy == GlobalValues.STRATEGY.AGGRESSIVE:
		decision = aggressive_strategy_logic()
	elif chosenStrategy == GlobalValues.STRATEGY.BALANCED:
		decision = balanced_strategy_logic()
		
	if decision != "" && decision != self.name:
		transition.emit(self, decision)


func aggressive_strategy_logic() -> String:
	var decision : String = ""
	var canAttack = owner.check_can_attack()
	var wantToAttack = owner.check_want_to_attack()
	
	if canAttack:
		decision = "BaseAttack"
	else:
		if owner.opponentIsAttacking:
			if wantToAttack:
				decision = "MoveForward"
			else:
				decision = "MoveBackward"
		else:
			if owner.distance_threshold_hit():
				decision = "Idle"
			else:
				decision = "MoveForward"
	
	return decision


func balanced_strategy_logic() -> String:
	var decision : String = ""
	var canAttack = owner.check_can_attack()
	#var wantToAttack = owner.check_want_to_attack()
	
	if canAttack:
		decision = "BaseAttack"
	else:
		if owner.distance < owner.distanceThreshold:
			decision = "MoveBackward"
		elif owner.distance > owner.distanceThreshold:
			decision = "MoveForward"
		else:
			decision = "Idle"
	
	return decision
