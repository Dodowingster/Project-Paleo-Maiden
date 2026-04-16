extends Camera2D
class_name CustomCamera

@export var decay : float = 0.8
@export var max_offset : Vector2 = Vector2(30, 30)
@onready var noise : FastNoiseLite = FastNoiseLite.new()
@onready var noise_y : int = 0

@onready var trauma : float = 0.0
@export var trauma_power : int = 2

func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 4
	noise.fractal_octaves = 2
	
func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0)

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	#offset.x = max_offset.x * amount * randf_range(-1, 1)
	#offset.y = max_offset.y * amount * randf_range(-1, 1)
	noise_y += 1
	offset.x = max_offset.x * amount * noise.get_noise_2d(2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(3, noise_y)
