extends Sprite2D
class_name gridButtonObject

@onready var buttonColArea: Area2D = $buttonColArea

var buttonActiveSprite = load("uid://doat2jt07804x")
var buttonInactiveSprite = load("uid://drdxj1mf8d515")

var gridSpaceParent:gridSpace 

var buttonActivated:bool = false
var buttonConnectObjectPath:NodePath
var buttonConnectObject:gridButtonInteractable

signal activateButton
signal deactivateButton

func _ready() -> void:
	gridSpaceParent = get_parent()
	if gridSpaceParent.gridParent.get_node(buttonConnectObjectPath) is gridButtonInteractable:
		buttonConnectObject = gridSpaceParent.gridParent.get_node(buttonConnectObjectPath)
	else:
		push_error("Not a valid button connection at " + gridSpaceParent.name)
		return
	
	activateButton.connect(buttonConnectObject.onGridButtonPressed)
	deactivateButton.connect(buttonConnectObject.onGridButtonUnpress)

func _on_button_col_area_area_entered(area: Area2D) -> void:
	if area.name == "colArea":
		buttonActivated = true
		texture = buttonActiveSprite
		activateButton.emit()

func _on_button_col_area_area_exited(area: Area2D) -> void:
	await get_tree().process_frame
	if area.name == "colArea":
		texture = buttonInactiveSprite
		buttonActivated = false
		deactivateButton.emit()
		print(buttonColArea.get_overlapping_areas()) #implement system to keep button activated if line is still in
