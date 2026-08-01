extends Control

@export var playFullCutscene:bool = true

@onready var delamLogo: TextureRect = $delamLogo
@onready var flobLogo: TextureRect = $flobLogo
@onready var introCutsceneAnim: AnimationPlayer = $introCutsceneAnim

var cutsceneTween:Tween
var delamIntroSFX = "uid://fdpfde1wduyr"
var menuWIntroSFX = "uid://b7qtqdhfrybcs"

var canContiue:bool = false
var canSkip:bool = true

func _ready() -> void:
	if self.playFullCutscene == false:
		canSkip = false
		canContiue = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("uiBack"):
		if canSkip:
			loadMenuScene()
	elif event.is_pressed():
		if canContiue:
			loadMenuScene()

func playDelamSFX():
	GlobalAudioManager.playMusic(delamIntroSFX, -2.0)
func playIntroWIntro():
	GlobalAudioManager.playMusic(menuWIntroSFX, -10.0)

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
