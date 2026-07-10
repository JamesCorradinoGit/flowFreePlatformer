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
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN_OUT)
		add_child(instWM)
		instWM.global_position = self.menuStartPos.global_position
		tween.tween_property(instWM, "global_position", menuEndPos.position, 0.5)
		await tween.finished
		instWM.introTweenComplete.emit()
	else:
		instWM.queue_free()

func _on_back_button_pressed() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx
	GlobalSceneLoader.loadScene("uid://cm0dmoglwp1ru")

func _on_back_button_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
