class_name VFX
extends Node2D

@onready var anim_player : AnimationPlayer = %AnimationPlayer
@onready var freeze_frames : int = 0

func _ready() -> void:
	anim_player.play("play")

func _physics_process(_delta: float) -> void:
	if freeze_frames > 0:
		anim_player.speed_scale = 0
		freeze_frames -= 1
	else:
		anim_player.speed_scale = 1

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
