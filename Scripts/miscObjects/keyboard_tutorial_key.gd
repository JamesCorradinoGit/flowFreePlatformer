extends Sprite2D

@export var letterToDisplay:String
@export var inputToTrack:String
@export var keyTweenTime:float = 0.05
@onready var keyLabel: Label = $keyLabel

var activeTween:Tween

var origScale:Vector2

func _ready() -> void:
	keyLabel.text = letterToDisplay
	origScale = scale

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(inputToTrack):
		if activeTween:
			activeTween.kill()
		activeTween = create_tween()
		activeTween.parallel()
		activeTween.tween_property(self, "scale", scale*0.9, keyTweenTime)
		activeTween.tween_property(self, "modulate", Color(0.58, 0.58, 0.58, 1.0), keyTweenTime)
	if event.is_action_released(inputToTrack):
		if activeTween:
			activeTween.kill()
		activeTween = create_tween()
		activeTween.parallel()
		activeTween.tween_property(self, "scale", origScale, keyTweenTime)
		activeTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), keyTweenTime)
