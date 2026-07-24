extends Panel
class_name smallWorldMenuPanel

@export var worldLabel:Label
@export var lvlPanelVbox:VBoxContainer

var levelDetailSceneRef:PackedScene = load("uid://bsfnbublguw18")

func _ready() -> void:
	if Globals.currentWorldResource:
		worldLabel.text = Globals.currentWorldResource.worldName
		for lvl in Globals.currentWorldResource.levelsResource:
			var instLVLDetail:levelInfoPanel = levelDetailSceneRef.instantiate().duplicate()
			instLVLDetail.levelResourceToLoad = lvl
			lvlPanelVbox.add_child(instLVLDetail)
