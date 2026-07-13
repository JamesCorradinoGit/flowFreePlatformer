extends Node

@onready var popupRef:PackedScene = preload("uid://5pe1hsybkpns")
var currentPopup: popupMessageObject

func showMessage(popupName:String, popupMessage:String, popupDuration:float, overrideParent:Node = null):
	if currentPopup == null:
		var instPopup:popupMessageObject = popupRef.instantiate().duplicate()
		currentPopup = instPopup
		instPopup.global_position = Vector2.ZERO
		if overrideParent:
			overrideParent.add_child(instPopup)
		else:
			add_child(instPopup)
		instPopup.displayMessage.emit(popupName, popupMessage, popupDuration)
