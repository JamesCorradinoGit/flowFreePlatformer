extends Control
class_name endScreen

@export var menuScene:PackedScene
@onready var endWorldLabel: Label = $endingPanel/endWorldLabel
@onready var endNameLabel: Label = $endingPanel/endNameLabel

var instWorldName:String = "N/A"
var instLevelName:String = "N/A"

func _ready() -> void:
	endWorldLabel.text = instWorldName
	endNameLabel.text = instLevelName

func _on_menu_button_pressed() -> void:
	GlobalSceneLoader.loadScene(str(menuScene.resource_path))

func _on_reset_button_pressed() -> void:
	GlobalSceneLoader.loadScene(str(get_tree().current_scene.scene_file_path))
