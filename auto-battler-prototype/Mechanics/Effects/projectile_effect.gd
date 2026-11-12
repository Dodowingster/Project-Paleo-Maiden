class_name ProjectileEffect
extends Effect

@export var spawn_frame : int
@export var spawn_velocity : Vector2
@export var spawn_location : Vector2
@export var duration : float
@export var projectile : PackedScene

@onready var character : Character
@onready var time_elapsed : float = 0
@onready var triggered : bool = false


func execute_effect(delta: float) -> void:
	if not triggered:
		if time_elapsed > (spawn_frame / 60.0):
			var spawn_node = projectile.instantiate()
			if spawn_node is Projectile:
				spawn_node.projectile_owner = character
				spawn_node.speed_x = spawn_velocity.x
				spawn_node.lifetime = duration
				spawn_node.side = character.get_side()
				# what is wrong with my character's global position bruh
				spawn_node.global_position = character.global_position + \
				Vector2(spawn_location.x * spawn_node.side, spawn_location.y)
				print(character.global_position)
			get_tree().current_scene.add_child(spawn_node)
			print(spawn_node.global_position)
			triggered = true
		time_elapsed += delta

func execute_physics_effect(_delta: float) -> void:
	pass

func reset() -> void:
	time_elapsed = 0
	triggered = false
