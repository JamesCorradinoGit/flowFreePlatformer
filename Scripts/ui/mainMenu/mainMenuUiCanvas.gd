extends Control
class_name mainMenuCanvas

@export var buttons: Array[Button]
@export var removeDist: float = 500.0
@export var timeToRemove: float = 0.5
@export_subgroup("Extra Menus")
@export var extraMenuPos: Marker2D
@export var settingsMenuRef: PackedScene

@warning_ignore_start("unused_signal")
signal removeButtons
signal showButtons
signal moveButtonsLeftDone
signal disableButtons
signal enableButtons
signal showSettings
signal hideSettings

var isSettingsVisible: bool = false
var settingsMenuInstRef: settingsMenu
var settingsMenuTweenTime:float = 0.5

func _ready() -> void:
	removeButtons.connect(moveButtonsOut)
	showButtons.connect(moveButtonsIn)
	disableButtons.connect(disableAllButtons)
	enableButtons.connect(enableAllButtons)
	showSettings.connect(showSettingsFunc)
	hideSettings.connect(hideSettingsFunc)

func showSettingsFunc():
	var settingsInst:settingsMenu = settingsMenuRef.instantiate()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	isSettingsVisible = true
	
	settingsInst.global_position = Vector2(extraMenuPos.global_position.x, extraMenuPos.global_position.y + 1000)
	add_child(settingsInst)
	settingsMenuInstRef = settingsInst
	tween.tween_property(settingsInst, "global_position", extraMenuPos.global_position, settingsMenuTweenTime)
func hideSettingsFunc():
	var tween = create_tween()
	tween.tween_property(settingsMenuInstRef, "global_position", Vector2(settingsMenuInstRef.global_position.x, settingsMenuInstRef.global_position.y + 1000), settingsMenuTweenTime)

func moveButtonsOut():
	disableButtons.emit()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:x", -removeDist, timeToRemove)
func moveButtonsIn():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:x", 0.0, timeToRemove)
	await tween.finished
	enableButtons.emit()

func disableAllButtons():
	for button:Button in buttons:
		button.disabled = true
		if "doLocalButtonTween" in button:
			button.doLocalButtonTween = false
func enableAllButtons():
	for button:Button in buttons:
		button.disabled = false
		if "doLocalButtonTween" in button:
			button.doLocalButtonTween = true
