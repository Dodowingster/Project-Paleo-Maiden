extends Control

@export var offset_y : int = 40
@export var section_direction : GlobalValues.Direction = GlobalValues.Direction.LEFT
@onready var generic_popup = preload("res://UI/Popups/GenericPopup.tscn")
@onready var popup_list : Array[BonusPopUp] = []


func connect_to_character(character : Character) -> void:
	for connection in character.popup_affinity.get_connections():
		character.popup_affinity.disconnect(connection["callable"])
	character.popup_affinity.connect(add_popup)

func add_popup(aff_bonus_name : String) -> void:
	var generic_popup_node : Node = generic_popup.instantiate()
	if generic_popup_node is BonusPopUp:
		generic_popup_node.process_mode = Node.PROCESS_MODE_ALWAYS
		generic_popup_node.offset = 200
		generic_popup_node.popup_text = aff_bonus_name
		generic_popup_node.popup_direction = section_direction
		generic_popup_node.popup_finished.connect(remove_popup)

		# manage spawn height
		generic_popup_node.position.y += offset_y * popup_list.size()
		popup_list.append(generic_popup_node)
		self.add_child(generic_popup_node)

func remove_popup() -> void:
	popup_list.pop_front().queue_free()
