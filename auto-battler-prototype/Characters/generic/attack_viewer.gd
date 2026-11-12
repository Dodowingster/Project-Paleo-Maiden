@tool
class_name AttackViewer
extends Node2D

@export var technique_data : TechniqueData:
	set(value):
		technique_data = value
		queue_redraw()

func _draw():
	if not technique_data:
		return
	if not technique_data.hitboxes:
		return
	if Engine.is_editor_hint():
		for hitbox in technique_data.hitboxes:
			draw_set_transform(hitbox.location, 0, Vector2.ONE)
			if hitbox.hitbox_shape is RectangleShape2D:
				var size = hitbox.hitbox_shape.size
				draw_rect(Rect2(-size/2, size), Color(0.69, 0, 0, 0.41), true, 2)
		for hurtbox in technique_data.hurtboxes:
			draw_set_transform(hurtbox.location, 0, Vector2.ONE)
			if hurtbox.hurtbox_shape is RectangleShape2D:
				var size = hurtbox.hurtbox_shape.size
				draw_rect(Rect2(-size/2, size), Color(0, 0.6, 0, 0.42), true, 2)
