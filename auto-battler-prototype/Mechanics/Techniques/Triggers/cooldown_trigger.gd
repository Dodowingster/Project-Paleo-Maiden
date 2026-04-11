extends Trigger
class_name CooldownTrigger

@onready var character : Character
@export var cooldown : float
@onready var currentTimer : float = 0
@export var startWithCooldown : bool = true
@onready var conditionPassed : bool = false
@export var startingCooldown : float

func check_condition() -> bool:
	return conditionPassed

func _ready() -> void:
	if startWithCooldown:
		currentTimer = startingCooldown

func _process(delta: float) -> void:
	#internalTimer += delta
	if !conditionPassed and currentTimer > 0:
		currentTimer -= delta
	elif currentTimer <= 0:
		conditionPassed = true

func reset() -> void:
	conditionPassed = false
	currentTimer = cooldown
	#print("Time: " + str(internalTimer))
