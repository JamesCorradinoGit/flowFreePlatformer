extends Sprite2D
class_name playerButtonMechanism

@export var buttonColor: Color
@export var objToConnectTo: interactableMechanism
@export var mechanismID:int = 0

@onready var innerLight: Sprite2D = $innerLight

var posYOffset:float = 5
var newYPos:float
var originYPos:float
var activeTween:Tween
var tweenTime:float = 0.1

func _ready() -> void:
	innerLight.self_modulate = buttonColor
	originYPos = position.y
	newYPos = position.y + posYOffset

func _on_button_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GlobalAudioManager.playGlobalSFX("uid://obo52s32r5f0", -2.0, randf_range(-0.25, 0.25))
		activeTween = create_tween()
		activeTween.set_parallel()
		activeTween.tween_property(self, "position:y", newYPos, tweenTime)
		if objToConnectTo:
			objToConnectTo.mechanismConnect.emit(mechanismID)

func _on_button_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		GlobalAudioManager.playGlobalSFX("uid://bqwaoxf3r1yfj", -2.0, randf_range(-0.25, 0.25))
		activeTween = create_tween()
		activeTween.set_parallel()
		activeTween.tween_property(self, "position:y", originYPos, tweenTime)
		if objToConnectTo:
			objToConnectTo.mechanismDisconnect.emit(mechanismID)
