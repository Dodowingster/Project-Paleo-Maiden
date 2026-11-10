class_name CooldownTrigger
extends Trigger

@export var cooldown : float
@export var start_with_cooldown : bool = true
@export var starting_cooldown : float

@onready var character : Character
@onready var current_timer : float = 0
@onready var condition_passed : bool = false

func check_condition() -> bool:
	return condition_passed

func _ready() -> void:
	if start_with_cooldown:
		current_timer = starting_cooldown

func _process(delta: float) -> void:
	#internalTimer += delta
	if !condition_passed and current_timer > 0:
		current_timer -= delta
	elif current_timer <= 0:
		condition_passed = true

func force_ready() -> void:
	current_timer = 0
	condition_passed = true

func reset() -> void:
	condition_passed = false
	current_timer = cooldown
	#print("Time: " + str(internalTimer))
