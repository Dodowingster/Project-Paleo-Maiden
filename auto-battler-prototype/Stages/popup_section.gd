extends Control

@export var sectionDirection : GlobalValues.DIRECTION = GlobalValues.DIRECTION.LEFT
@onready var genericPopup = preload("res://UI/Popups/GenericPopup.tscn")

func connect_to_character(character : Character) -> void:
	for connection in character.popupAffinity.get_connections():
		character.popupAffinity.disconnect(connection["callable"])
	character.popupAffinity.connect(add_popup)

func add_popup(affBonusName : String) -> void:
	var genericPopupNode : Node = genericPopup.instantiate()
	if genericPopupNode is BonusPopUp:
		genericPopupNode.offset = 300
		genericPopupNode.popupText = affBonusName
		genericPopupNode.popupDirection = sectionDirection
		self.add_child(genericPopupNode)
