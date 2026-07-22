extends Button

@export var sceneToSwitch: PackedScene
@export_subgroup("Tweens")
@export var doTween: bool = false
@export var tweenOffset: Vector2
@export var tweenTime: float = 0.25

var combinedTweenPos:Vector2
var originPos:Vector2
var doLocalButtonTween: bool = true

#CONNECT SIGNALS

func _ready() -> void:
	if self.doTween:
		originPos = global_position
		combinedTweenPos = global_position + tweenOffset

func _on_pressed() -> void:
	GlobalSceneLoader.loadScene(str(sceneToSwitch.resource_path))
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0)

func _on_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0)
	if doLocalButtonTween:
		var tween = create_tween()
		tween.tween_property(self, "global_position", combinedTweenPos, tweenTime)

func _on_mouse_exited() -> void:
	if doLocalButtonTween:
		var tween = create_tween()
		tween.tween_property(self, "global_position", originPos, tweenTime)
