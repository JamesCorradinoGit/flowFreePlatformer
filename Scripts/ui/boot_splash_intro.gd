extends Control

@onready var customBootSplashAnim: AnimationPlayer = $customBootSplashAnim

func _ready() -> void:
	await customBootSplashAnim.animation_finished
	GlobalSceneLoader.loadScene("uid://cm0dmoglwp1ru")
