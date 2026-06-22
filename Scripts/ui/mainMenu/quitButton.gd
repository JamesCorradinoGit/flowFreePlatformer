extends Button

@export var doTween: bool = false
@export var tweenOffset: Vector2
@export var tweenTime: float = 0.25

var combinedTweenPos:Vector2
var originPos:Vector2

#CONNECT SIGNALS

func _ready() -> void:
	if self.doTween:
		originPos = global_position
		combinedTweenPos = global_position + tweenOffset

func _on_pressed() -> void:
	get_tree().quit()

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", combinedTweenPos, tweenTime)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", originPos, tweenTime)
