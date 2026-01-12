extends State
class_name ActionableState

func update(_delta: float):
	var decision : String = ""
	var chosenStrategy: GlobalValues.STRATEGY = owner.strategy

	if chosenStrategy == GlobalValues.STRATEGY.AGGRESSIVE:
		decision = aggressive_strategy_logic()
	elif chosenStrategy == GlobalValues.STRATEGY.BALANCED:
		decision = balanced_strategy_logic()
	elif chosenStrategy == GlobalValues.STRATEGY.DEFENSIVE:
		decision = defensive_strategy_logic()
		
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
			if owner.min_distance_hit():
				if owner.opponent.min_distance_hit() and owner.canClash and owner.opponent.canClash:
					decision = "Clashing"
				else:
					decision = "Idle"
			else:
				decision = "MoveForward"
	
	return decision


func balanced_strategy_logic() -> String:
	var decision : String = ""
	#var canAttack = owner.check_can_attack()
	var wantToAttack = owner.check_want_to_attack()
	
	if self.name == "Idle":
		decision = "MoveBackward"
		
	if wantToAttack:
		#if canAttack:
		if owner.distance > owner.maxDistance:
			decision = "MoveForward"
		elif owner.distance < owner.minDistance:
			decision = "MoveBackward"
		else:
			decision = "BaseAttack"
		#else:
			#decision = "MoveForward"
	else:
		if owner.opponentIsAttacking:
			decision = "MoveBackward"
		else:
			if owner.min_distance_hit():
				decision = "MoveBackward"
			elif owner.distance > owner.maxDistance:
				decision = "MoveForward"
	
	return decision


func defensive_strategy_logic() -> String:
	var decision : String = ""
	var canAttack = owner.check_can_attack()
	var wantToAttack = owner.check_want_to_attack()
	
	if wantToAttack:
		if canAttack:
			decision = "BaseAttack"
		else:
			if owner.distance > owner.minDistance:
				decision = "MoveForward"
			else:
				decision = "Idle"
	else:
		decision = "MoveBackward"
	
	return decision
