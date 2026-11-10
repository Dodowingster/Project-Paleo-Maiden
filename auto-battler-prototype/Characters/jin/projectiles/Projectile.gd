class_name Projectile
extends Node2D

@export var speed_x = 1500
@export var lifetime : float = 1
@export var despawn_on_hit : bool = false

@onready var anim_player : AnimationPlayer = %AnimationPlayer

@onready var wave_sprite : Sprite2D = %WaveSprite
@onready var hitbox : HitBox = %WaveHitbox

@onready var time_left = 0
@onready var side
@onready var projectile_owner : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = lifetime
	wave_sprite.scale.x = wave_sprite.scale.x * side
	var hitbox_areas = hitbox.get_children()
	for hitbox_area in hitbox_areas:
		hitbox_area.position.x = hitbox_area.position.x * side
		hitbox.hit_detected.connect(on_hit)

	anim_player.play("launch")


func set_params(side_val: int):
	side = side_val


func on_hit() -> void:
	if despawn_on_hit:
		anim_player.play("despawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !anim_player.is_playing():
		anim_player.play("travel")
	if time_left > 0:
		time_left -= delta

	if time_left <= 0:
		anim_player.play("despawn")

func _physics_process(delta):
	if anim_player.current_animation != "launch":
		position.x += speed_x * delta * side


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "despawn":
		queue_free()
		print("Projectile died")
