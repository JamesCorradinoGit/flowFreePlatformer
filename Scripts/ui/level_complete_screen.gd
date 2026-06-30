extends Control
class_name endScreen

@export var menuScene:PackedScene
@onready var endWorldLabel: Label = $endingPanel/endWorldLabel
@onready var endNameLabel: Label = $endingPanel/endNameLabel
@onready var blurRect: ColorRect = $blurRect

var instWorldName:String = "N/A"
var instLevelName:String = "N/A"

func _ready() -> void:
	blurRect.material.set_shader_parameter("amount", 0.0)
	endWorldLabel.text = instWorldName
	endNameLabel.text = instLevelName
	var tween = create_tween()
	tween.tween_property($blurRect, "material:shader_parameter/amount", 1.5, 1.5)

func _on_menu_button_pressed() -> void:
	GlobalSceneLoader.loadScene(str(menuScene.resource_path))

func _on_reset_button_pressed() -> void:
	GlobalSceneLoader.loadScene(str(get_tree().current_scene.scene_file_path))
