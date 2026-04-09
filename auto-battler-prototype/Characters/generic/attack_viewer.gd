@tool
extends Node2D
class_name AttackViewer

@export var techniqueData : TechniqueData:
	set(value):
		techniqueData = value
		queue_redraw()

func _draw():
	if not techniqueData:
		return
	if not techniqueData.hitboxes:
		return
	if Engine.is_editor_hint():
		for hitbox in techniqueData.hitboxes:
			draw_set_transform(hitbox.location, 0, Vector2.ONE)
			if hitbox.hitboxShape is RectangleShape2D:
				var size = hitbox.hitboxShape.size
				draw_rect(Rect2(-size/2, size), Color(0.69, 0, 0, 0.41), true, 2)
		for hurtbox in techniqueData.hurtboxes:
			draw_set_transform(hurtbox.location, 0, Vector2.ONE)
			if hurtbox.hurtboxShape is RectangleShape2D:
				var size = hurtbox.hurtboxShape.size
				draw_rect(Rect2(-size/2, size), Color(0, 0.6, 0, 0.42), true, 2)
