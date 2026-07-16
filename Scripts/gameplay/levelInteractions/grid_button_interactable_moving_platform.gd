extends gridButtonInteractable

@export var newPosOffset:Vector2

var newPos:Vector2
var oldPos:Vector2

func _ready() -> void:
	newPos = position + newPosOffset
	await get_tree().process_frame
	oldPos = position

func onGridButtonPressed():
	var tween = create_tween()
	tween.tween_property(self, "position", newPos, 0.5)

func onGridButtonUnpress():
	var tween = create_tween()
	tween.tween_property(self, "position", oldPos, 0.5)
