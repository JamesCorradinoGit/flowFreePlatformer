extends Panel
class_name levelInfoPanel

@export var levelResourceToLoad:levelResource
@export var levelNameLabel:Label
@export var levelCompletedIcon:TextureRect
@export var levelUnlockedIcon:TextureRect

var checkIcon = load("uid://dhswweww3ldkj")

func _ready() -> void:
	if levelResourceToLoad:
		if levelResourceToLoad.completed:
			levelCompletedIcon.texture = checkIcon
		if levelResourceToLoad.unlocked:
			levelCompletedIcon.texture = checkIcon
			levelNameLabel.text = levelResourceToLoad.levelName
		else:
			levelNameLabel.text = "Unlock level to view name!"
