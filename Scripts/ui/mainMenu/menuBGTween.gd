extends Sprite2D

@export var pos1: Vector2
@export var pos2: Vector2
@export var speed: float = 5.0

func _ready() -> void:
	bgPan()

func bgPan():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
	tween.tween_property(self, "position", pos2, speed)
	tween.tween_property(self, "position", pos1, speed)
