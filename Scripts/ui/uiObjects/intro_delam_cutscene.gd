extends Control

@export var playFullCutscene:bool = true

@onready var delamLogo: TextureRect = $delamLogo
@onready var flobLogo: TextureRect = $flobLogo
@onready var introCutsceneAnim: AnimationPlayer = $introCutsceneAnim

var cutsceneTween:Tween
var delamIntroSFX = "uid://fdpfde1wduyr"
var menuWIntroSFX = "uid://b7qtqdhfrybcs"
var introSong = "uid://v7f7be5nm8sn"

var transitioned:bool = false

var canContiue:bool = false
var canSkip:bool = true

func _ready() -> void:
	if self.playFullCutscene == false:
		canSkip = false
		canContiue = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("uiBack"):
		if canSkip and transitioned == false:
			transitioned = true
			loadMenuScene()
	elif event.is_pressed():
		if canContiue and transitioned == false:
			transitioned = true
			loadMenuScene()

func playDelamSFX():
	GlobalAudioManager.playMusic(delamIntroSFX, -5.0)
func playIntroWIntro():
	GlobalAudioManager.playMusic(menuWIntroSFX, -15.0)
func playRealIntro():
	GlobalAudioManager.fadeOutMusicRemove(0.5)
	await get_tree().create_timer(0.55).timeout
	GlobalAudioManager.playMusic(introSong, -17.5)

func enableNextSceneClick():
	canContiue = true
	canSkip = false
	#GlobalAudioManager.fadeOutMusicRemove(9.5)
	await get_tree().create_timer(10).timeout
	loadMenuScene()
func loadMenuScene():
	GlobalSceneLoader.loadScene("uid://cm0dmoglwp1ru")
	GlobalAudioManager.fadeOutMusicRemove()

func checkIfCutsceneShouldContinue():
	if self.playFullCutscene == false:
		introCutsceneAnim.stop()
	else:
		pass
