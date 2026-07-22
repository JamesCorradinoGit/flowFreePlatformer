extends Panel
class_name smallWorldMenuPanel

@export var worldLabel:Label

var levelDetailSceneRef = load("uid://bsfnbublguw18")

func _ready() -> void:
	if Globals.currentWorldResource:
		worldLabel.text = Globals.currentWorldResource.worldName
