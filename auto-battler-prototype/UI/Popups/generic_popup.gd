extends PanelContainer
class_name BonusPopUp

@export var offset : int = 200
@export var popupDirection : GlobalValues.DIRECTION = GlobalValues.DIRECTION.LEFT
@export var popupText = ""

func _ready() -> void:
	var pop_mod : int = 1
	if popupDirection == GlobalValues.DIRECTION.RIGHT:
		pop_mod = -1
	self.position.x -= offset * pop_mod
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	self.get_child(0).text = popupText
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"position", Vector2(self.position.x + (offset * pop_mod), self.position.y), 0.3).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.5).set_trans(Tween.TRANS_QUINT)
	tween.tween_callback(self.queue_free)
