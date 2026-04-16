extends Control

@export var sectionDirection : GlobalValues.DIRECTION = GlobalValues.DIRECTION.LEFT
@onready var genericPopup = preload("res://UI/Popups/GenericPopup.tscn")
@onready var popupList : Array[BonusPopUp] = []
@export var offset_y : int = 40

func connect_to_character(character : Character) -> void:
	for connection in character.popupAffinity.get_connections():
		character.popupAffinity.disconnect(connection["callable"])
	character.popupAffinity.connect(add_popup)

func add_popup(affBonusName : String) -> void:
	var genericPopupNode : Node = genericPopup.instantiate()
	if genericPopupNode is BonusPopUp:
		genericPopupNode.offset = 200
		genericPopupNode.popupText = affBonusName
		genericPopupNode.popupDirection = sectionDirection
		genericPopupNode.popupFinished.connect(remove_popup)
		
		# manage spawn height
		genericPopupNode.position.y += offset_y * popupList.size()
		popupList.append(genericPopupNode)
		self.add_child(genericPopupNode)

func remove_popup() -> void:
	popupList.pop_front().queue_free()
