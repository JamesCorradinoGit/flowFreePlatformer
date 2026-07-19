extends Control
class_name levelSelectMenu

@export var currentWorldString:String = "N/A"
@export var currentWorldSelectScreen:worldMenuBase
@export_category("Marker Nodes")
@export var menuStartPos:Marker2D
@export var menuEndPos:Marker2D

var autoWorldMenu:PackedScene = load("uid://dnol85ea5mqof")
var bannerInTransition:bool = false

signal switchCurrentLoadedWorldCustom(newMenu:PackedScene)
signal switchCurrentLoadedWorldAuto(worldResource:levelWorld)

func _ready() -> void:
	switchCurrentLoadedWorldCustom.connect(switchWorldMenuCustom)
	switchCurrentLoadedWorldAuto.connect(switchWorldMenuAuto)
	if GlobalAudioManager.activeSong == null:
		GlobalAudioManager.playMusic(GlobalAudioManager.songList["menuWithoutIntro"], -10)

func switchWorldMenuCustom(newMenu:PackedScene):
	bannerInTransition = true
	var instWM:worldMenuBase = newMenu.instantiate() 
	if instWM.name != currentWorldString:
		if currentWorldString != "" and currentWorldSelectScreen:
			await tweenOutCurrentWorldMenu()
		currentWorldString = instWM.name
		currentWorldSelectScreen = instWM
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
	bannerInTransition = false
func switchWorldMenuAuto(worldResource:levelWorld):
	bannerInTransition = true
	if worldResource.worldName != currentWorldString:
		if currentWorldString != "" and currentWorldSelectScreen:
			await tweenOutCurrentWorldMenu()
		
		var instAutoWM:worldAutoMenu = autoWorldMenu.instantiate()
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN_OUT)
		currentWorldString = worldResource.worldName
		currentWorldSelectScreen = instAutoWM
		instAutoWM.worldToLoad = worldResource
		add_child(instAutoWM)
		instAutoWM.global_position = self.menuStartPos.global_position
		tween.tween_property(instAutoWM, "global_position", menuEndPos.position, 0.5)
		await tween.finished
		instAutoWM.introTweenComplete.emit()
	bannerInTransition = false
func tweenOutCurrentWorldMenu():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(currentWorldSelectScreen, "global_position", menuStartPos.position, 0.5)
	await tween.finished
	currentWorldSelectScreen.queue_free()

func _on_back_button_pressed() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx
	GlobalSceneLoader.loadScene("uid://cm0dmoglwp1ru")
func _on_back_button_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
