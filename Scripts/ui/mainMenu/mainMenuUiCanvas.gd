extends Control
class_name mainMenuCanvas

@export var buttons: Array[Button]
@export var removeDist: float = 500.0
@export var timeToRemove: float = 0.5

signal removeButtonsLeft
signal disableButtons

func _ready() -> void:
	removeButtonsLeft.connect(moveButtonsLeft)
	disableButtons.connect(disableAllButtons)

func moveButtonsLeft():
	disableButtons.emit()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:x", -removeDist, timeToRemove) #TODO disable buttons when clicked

func disableAllButtons():
	for button:Button in buttons:
		button.disabled = true
