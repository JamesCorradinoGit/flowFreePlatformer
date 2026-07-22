extends Control
class_name popupMessageObject

@onready var popupNameLabel: Label = $popupPanel/popupNamePanel/popupNameLabel
@onready var popupText: Label = $popupPanel/popupText
@onready var popupPanel: Panel = $popupPanel

signal displayMessage(name:String, message:String, duration:float)

func _ready() -> void:
	displayMessage.connect(showObjectMsg)

func showObjectMsg(popupName:String, popupMessage:String, popupDuration:float):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	popupNameLabel.text = popupName
	popupText.text = popupMessage
	tween.tween_property(popupPanel, "position:x", 20, 0.5)
	await get_tree().create_timer(popupDuration).timeout
	var tween2 = create_tween()
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(popupPanel, "position:x", -362, 0.5)
	await tween2.finished
	queue_free()
