extends CanvasLayer
class_name LoadingScreen

signal loadingScreenReady

@export var transitionPlayer: AnimationPlayer

func _ready() -> void:
	transitionPlayer.play("crossfade")
	await transitionPlayer.animation_finished
	loadingScreenReady.emit()

func onProgressChanged(_newVal:float) -> void:
	pass

func onLoadFinished() -> void:
	transitionPlayer.play_backwards("crossfade")
	await transitionPlayer.animation_finished
	queue_free()
