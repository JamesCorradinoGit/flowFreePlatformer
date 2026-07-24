extends Node2D

var activeTween:Tween
var tweenTime = 0.1

func _process(_delta: float) -> void:
	if Globals.isAlreadyDragging:
		if activeTween:
			activeTween.kill()
		activeTween = create_tween()
		activeTween.tween_property(self, "modulate:a", 1.0, tweenTime)
	else:
		if activeTween:
			activeTween.kill()
		activeTween = create_tween()
		activeTween.tween_property(self, "modulate:a", 0.0, tweenTime)
