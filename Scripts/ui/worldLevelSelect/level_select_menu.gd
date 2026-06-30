extends Control
class_name levelSelectMenu

@export var currentWorldString:String = "N/A"
@export var currentWorldSelectScreen:PackedScene
@export_category("Marker Nodes")
@export var menuStartPos:Marker2D
@export var menuEndPos:Marker2D

signal switchCurrentLoadedWorld(newMenu:PackedScene)

func _ready() -> void:
	switchCurrentLoadedWorld.connect(switchWorldMenu)

func switchWorldMenu(newMenu:PackedScene):
	var instWM:worldMenuBase = newMenu.instantiate()
	if instWM.name != currentWorldString:
		currentWorldString = instWM.name
		currentWorldSelectScreen = newMenu
		var tween = create_tween()
		add_child(instWM)
		instWM.global_position = self.menuStartPos.global_position
		tween.tween_property(instWM, "global_position", menuEndPos.position, 0.5)
		await tween.finished
		instWM.introTweenComplete.emit()
	else:
		instWM.queue_free()
