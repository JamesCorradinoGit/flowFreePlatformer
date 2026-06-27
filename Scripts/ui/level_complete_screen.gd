extends Control

@export var levelCompleteBanner: Panel

var screenSizeX = DisplayServer.screen_get_size().x

signal moveBanner

func _ready() -> void:
	moveBanner.connect(moveBannerFunc)

func moveBannerFunc():
	pass
