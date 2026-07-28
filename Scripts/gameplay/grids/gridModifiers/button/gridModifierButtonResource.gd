extends gridMiddleModifierObject
class_name gridButton

@export var buttonColor:Color
@export var objToConnectTo:Array[NodePath]
@export_subgroup("Mechanism Control")
@export var useMechanismButton = true
@export var mechanismID:int = 0

var buttonScene:PackedScene = load("uid://2ti80hg2dxt0")
var buttonMechScene:PackedScene = load("uid://dpd6n0qgqve4c")

func instanceGridObject() -> Node2D:
	if useMechanismButton == false:
		var newButton:gridButtonObject = buttonScene.instantiate().duplicate()
		newButton.self_modulate = buttonColor
		newButton.buttonConnectObjectPath = objToConnectTo
		return newButton
	else:
		var newButton:gridButtonMechanismObject = buttonMechScene.instantiate().duplicate()
		newButton.self_modulate = buttonColor
		newButton.buttonConnectObjectPath = objToConnectTo
		newButton.mechanismID = mechanismID
		return newButton
