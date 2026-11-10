class_name Hurtbox
extends Area2D

@onready var last_group_collision = ""
@onready var last_group_hit_cooldown_default = 0.1
@onready var last_group_hit_cooldown = 0

func _init() -> void:
	collision_layer = 4
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", on_area_entered)

func _physics_process(delta):
	if last_group_collision != "" and last_group_hit_cooldown > 0:
		last_group_hit_cooldown -= delta

func on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	var allow_hit = true;
	if owner.has_method("get_hit") and hitbox.owner != owner:
		if "projectileOwner" in hitbox.owner:
			if hitbox.owner.projectileOwner == owner:
				return
		if hitbox.group_name.length() > 0:
			if last_group_collision == hitbox.group_name:
				if last_group_hit_cooldown > 0:
					allow_hit = false
			#else:
				#last_group_hit_cooldown <= 0
			if last_group_hit_cooldown <= 0:
				last_group_collision = hitbox.group_name
				last_group_hit_cooldown = last_group_hit_cooldown_default
		if allow_hit:
			print(last_group_collision)
			hitbox.hit_detected.emit()
			owner.get_hit(hitbox, self);

#func _on_area_exited(hitbox: HitBox) -> void:
	##last_group_collision = ""
	#pass
