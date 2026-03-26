extends Node2D
class_name VFX

@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var freeze_frames : int = 0

func _ready() -> void:
	animPlayer.play("play")

func _physics_process(_delta: float) -> void:
	if freeze_frames > 0:
		animPlayer.speed_scale = 0
		freeze_frames -= 1
	else:
		animPlayer.speed_scale = 1

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
