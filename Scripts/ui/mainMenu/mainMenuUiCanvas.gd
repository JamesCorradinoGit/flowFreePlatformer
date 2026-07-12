extends Control
class_name mainMenuCanvas

@export var buttons: Array[Button]
@export var removeDist: float = 500.0
@export var timeToRemove: float = 0.5
@export_subgroup("Extra Menus")
@export var extraMenuPos: Marker2D
@export var settingsMenuRef: PackedScene
@export var extrasMenuRef: PackedScene

@warning_ignore_start("unused_signal")
signal removeButtons
signal showButtons
signal disableButtons
signal enableButtons
signal showExtraMenu(menu:String)
signal hideExtraMenu
signal moveButtonsLeftDone #TODO change these for the 3rd time

var isExtraMenuVisible: bool = false
var extraMenuInstRef: Control
var extraMenuTweenTime:float = 0.5

func _ready() -> void:
	removeButtons.connect(moveButtonsOut)
	showButtons.connect(moveButtonsIn)
	disableButtons.connect(disableAllButtons)
	enableButtons.connect(enableAllButtons)
	showExtraMenu.connect(showExtraMenuFunc)
	hideExtraMenu.connect(hideExtraMenuFunc)
	if GlobalAudioManager.activeSong == null:
		GlobalAudioManager.playMusic(GlobalAudioManager.songList["menuWithoutIntro"], -10)

func showExtraMenuFunc(menu:String):
	var localExtraMenu
	match menu:
		"settings":
			localExtraMenu = settingsMenuRef
		"extras":
			localExtraMenu = extrasMenuRef
		_:
			localExtraMenu = null
			return
	var extraMenuInst:Control = localExtraMenu.instantiate()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	isExtraMenuVisible = true
	
	extraMenuInst.global_position = Vector2(extraMenuPos.global_position.x, extraMenuPos.global_position.y + 1000)
	add_child(extraMenuInst)
	extraMenuInstRef = extraMenuInst
	tween.tween_property(extraMenuInst, "global_position", extraMenuPos.global_position, extraMenuTweenTime)
func hideExtraMenuFunc():
	var tween = create_tween()
	tween.tween_property(extraMenuInstRef, "global_position", Vector2(extraMenuInstRef.global_position.x, extraMenuInstRef.global_position.y + 1000), extraMenuTweenTime)

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
