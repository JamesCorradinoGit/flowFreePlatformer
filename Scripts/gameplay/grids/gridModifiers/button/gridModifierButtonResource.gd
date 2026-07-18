extends gridMiddleModifierObject
class_name gridButton

@export var buttonColor:Color
@export var objToConnectTo:Array[NodePath]

var buttonScene:PackedScene = load("uid://2ti80hg2dxt0")

func instanceGridObject() -> Node2D:
	var newButton:gridButtonObject = buttonScene.instantiate().duplicate()
	newButton.self_modulate = buttonColor
	newButton.buttonConnectObjectPath = objToConnectTo
	return newButton
