extends Node2D
class_name Projectile

@export var speedX = 1500
@export var lifetime : float = 1
@onready var timeleft = 0
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var waveSprite : Sprite2D = %WaveSprite
@onready var hitbox : HitBox = %WaveHitbox
@export var despawnOnHit : bool = false
@onready var side
@onready var projectileOwner : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	timeleft = lifetime
	waveSprite.scale.x = waveSprite.scale.x * side
	var hitboxAreas = hitbox.get_children()
	for hitboxArea in hitboxAreas:
		hitboxArea.position.x = hitboxArea.position.x * side
		hitbox.hitDetected.connect(on_hit)
	
	animPlayer.play("launch")
	

func setParams(sideVal:int):
	side = sideVal


func on_hit() -> void:
	if despawnOnHit:
		animPlayer.play("despawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !animPlayer.is_playing():
		animPlayer.play("travel")
	if timeleft > 0:
		timeleft -= delta
	
	if timeleft <= 0:
		animPlayer.play("despawn")

func _physics_process(delta):
	if animPlayer.current_animation != "launch":
		position.x += speedX * delta * side


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "despawn":
		queue_free()
		print("Projectile died")
