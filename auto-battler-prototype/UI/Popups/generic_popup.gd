class_name BonusPopUp
extends PanelContainer

signal popup_finished()

@export var offset : int = 200
@export var popup_direction : GlobalValues.Direction = GlobalValues.Direction.LEFT
@export var popup_text = ""

func _ready() -> void:
	var pop_mod : int = 1
	if popup_direction == GlobalValues.Direction.RIGHT:
		pop_mod = -1
	self.position.x -= offset * pop_mod
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	self.get_child(0).text = popup_text
	var tween = get_tree().create_tween()

	tween.tween_property(self,"position", Vector2(self.position.x + (offset * pop_mod), \
	self.position.y), 0.3).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(self.popup_finished.emit)
