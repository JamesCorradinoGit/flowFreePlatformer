extends Sprite2D
class_name playerButtonInteractable

enum ACTIVE_TYPE {DISABLE_PLATFORM, MOVE_PLATFORM}

@export var buttonColor: Color
@export var objToConnectTo: Node2D
@export var buttonType: ACTIVE_TYPE = ACTIVE_TYPE.DISABLE_PLATFORM

@onready var innerLight: Sprite2D = $innerLight

var posYOffset:float = 5
var newYPos:float
var originYPos:float
var activeTween:Tween
var tweenTime:float = 0.1

signal buttonPressed(type:int)
signal buttonReleased(type:int)

func _ready() -> void:
	innerLight.self_modulate = buttonColor
	originYPos = position.y
	newYPos = position.y + posYOffset
	
	if objToConnectTo:
		if objToConnectTo.has_method("onPlayerButtonPressed"):
			buttonPressed.connect(objToConnectTo.onPlayerButtonPressed)
		else:
			push_warning("Player button "+str(self)+" has an invalid push connection. Make sure the object you are connecting to has the onPlayerButtonPressed method")
		
		if objToConnectTo.has_method("onPlayerButtonReleased"):
			buttonReleased.connect(objToConnectTo.onPlayerButtonReleased)
		else:
			push_warning("Player button "+str(self)+" has an invalid push connection. Make sure the object you are connecting to has the onPlayerButtonReleased method")
	else:
		push_warning("No connection at "+str(self))

func _on_button_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		activeTween = create_tween()
		activeTween.set_parallel()
		activeTween.tween_property(self, "position:y", newYPos, tweenTime)
		buttonPressed.emit(buttonType)

func _on_button_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		activeTween = create_tween()
		activeTween.set_parallel()
		activeTween.tween_property(self, "position:y", originYPos, tweenTime)
		buttonReleased.emit(buttonType)
