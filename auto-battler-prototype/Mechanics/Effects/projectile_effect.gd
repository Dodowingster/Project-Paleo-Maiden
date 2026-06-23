extends Effect
class_name ProjectileEffect

@onready var character : Character
@export var spawnFrame : int
@export var spawnVelocity : Vector2
@export var spawnLocation : Vector2
@export var duration : float
@onready var timeElapsed : float = 0
@onready var triggered : bool = false
@export var projectile : PackedScene

func execute_effect(delta: float) -> void:
	if not triggered:
		if timeElapsed > (spawnFrame / 60.0):
			var spawnNode = projectile.instantiate()
			if spawnNode is Projectile:
				spawnNode.projectileOwner = character
				spawnNode.speedX = spawnVelocity.x
				spawnNode.lifetime = duration
				spawnNode.side = character.get_side()
				# what is wrong with my character's global position bruh 
				spawnNode.global_position = character.global_position + Vector2(spawnLocation.x * spawnNode.side, spawnLocation.y)
				print(character.global_position)
			get_tree().current_scene.add_child(spawnNode)
			print(spawnNode.global_position)
			triggered = true
		timeElapsed += delta

func execute_physics_effect(delta: float) -> void:
	pass

func reset() -> void:
	timeElapsed = 0
	triggered = false
