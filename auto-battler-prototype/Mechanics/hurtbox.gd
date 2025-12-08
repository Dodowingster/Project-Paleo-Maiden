class_name Hurtbox
extends Area2D

@export var hurtboxArea : CollisionShape2D

@onready var lastGroupCollision = ""
@onready var lastGroupHitCooldownDefault = 0.1
@onready var lastGroupHitCooldown = 0

func _init() -> void:
	collision_layer = 4
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
func _physics_process(delta):
	if lastGroupCollision != "" and lastGroupHitCooldown > 0:
		lastGroupHitCooldown -= delta
	
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	else:
		var allowHit = true;
		if owner.has_method("get_hit") and hitbox.owner != owner:
			if "projectileOwner" in hitbox.owner:
				if hitbox.owner.projectileOwner == owner:
					return
			if hitbox.groupName.length() > 0:
				if lastGroupCollision == hitbox.groupName:
					if lastGroupHitCooldown > 0:
						allowHit = false
				else:
					lastGroupHitCooldown <= 0
				if lastGroupHitCooldown <= 0:
					lastGroupCollision = hitbox.groupName
					lastGroupHitCooldown = lastGroupHitCooldownDefault
			if allowHit:
				print(lastGroupCollision)
				owner.get_hit(hitbox, self);

func _on_area_exited(hitbox: HitBox) -> void:
	#lastGroupCollision = ""
	pass
