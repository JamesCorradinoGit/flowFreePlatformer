extends Sprite2D
class_name gridButtonMechanismObject

@onready var buttonColArea: Area2D = $buttonColArea

var buttonActiveSprite = load("uid://doat2jt07804x")
var buttonInactiveSprite = load("uid://drdxj1mf8d515")

var gridSpaceParent:gridSpace 
var mechanismID:int

var buttonActivated:bool = false
var buttonConnectObjectPath:Array[NodePath]
var buttonConnectObject:interactableMechanism

signal buttonPress(id:int)
signal buttonUnpress(id:int)

func _ready() -> void:
	gridSpaceParent = get_parent()
	for connection in buttonConnectObjectPath:
		if gridSpaceParent.gridParent.get_node(connection) is interactableMechanism:
			buttonConnectObject = gridSpaceParent.gridParent.get_node(connection)
			buttonPress.connect(buttonConnectObject.onMechanismConnect)
			buttonUnpress.connect(buttonConnectObject.onMechanismDisconnect)
			if buttonConnectObject is mechanismDoor:
				buttonPress.connect(buttonConnectObject.enableGridButtonVar)
				buttonUnpress.connect(buttonConnectObject.disableGridButtonVar)
		else:
			push_error("Not a valid button connection at " + gridSpaceParent.name)
			return

func _on_button_col_area_area_entered(area: Area2D) -> void:
	if area.name == "colArea":
		GlobalAudioManager.playGlobalSFX("uid://obo52s32r5f0", -2.0, randf_range(-0.25, 0.25))
		buttonActivated = true
		texture = buttonActiveSprite
		buttonPress.emit(mechanismID)

func _on_button_col_area_area_exited(area: Area2D) -> void:
	await get_tree().process_frame
	if buttonColArea.get_overlapping_areas():
		return
	elif area.name == "colArea":
		GlobalAudioManager.playGlobalSFX("uid://bqwaoxf3r1yfj", -2.0, randf_range(-0.25, 0.25))
		texture = buttonInactiveSprite
		buttonActivated = false
		buttonUnpress.emit(mechanismID)
