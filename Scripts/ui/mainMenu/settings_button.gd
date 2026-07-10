extends Button

@export var doTween: bool = false
@export var tweenOffset: Vector2
@export var tweenTime: float = 0.25
@export var canvasMenu: mainMenuCanvas

var combinedTweenPos:Vector2
var originPos:Vector2
var doLocalButtonTween:bool = true

#CONNECT SIGNALS

func _ready() -> void:
	if self.doTween:
		originPos = global_position
		combinedTweenPos = global_position + tweenOffset

func menuButtonsTweenFix():
	var tween = create_tween()
	var buttonReference = get_parent().find_child("playButton")
	tween.tween_property(self, "global_position", Vector2(buttonReference.global_position.x, global_position.y), 0.2)

func _on_pressed() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0)
	canvasMenu.removeButtons.emit()
	canvasMenu.showExtraMenu.emit("settings")
func _on_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0)
	if doLocalButtonTween:
		var tween = create_tween()
		tween.tween_property(self, "global_position", combinedTweenPos, tweenTime)
func _on_mouse_exited() -> void:
	if doLocalButtonTween:
		var tween = create_tween()
		tween.tween_property(self, "global_position", originPos, tweenTime)
