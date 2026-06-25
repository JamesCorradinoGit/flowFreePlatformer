extends Button

@export var tweenOffset: Vector2
@export var tweenTime: float = 0.25

var originPos:Vector2

#CONNECT SIGNALS

func _ready() -> void:
	await get_tree().process_frame
	originPos = self.global_position

func _on_pressed() -> void:
	print("hi")

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + tweenOffset, tweenTime)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", originPos, tweenTime)
