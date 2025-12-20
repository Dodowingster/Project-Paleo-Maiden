extends State
class_name ActionableState

func update(_delta: float):
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
		
	if decision != "" && decision != self.name:
		transition.emit(self, decision)
