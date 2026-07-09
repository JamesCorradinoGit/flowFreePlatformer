extends Sprite2D
@export var colors: Array[Color]
@export var trailChild: Line2D
@export var waveAmp: float = 1
@export var waveFreq: float = 1
@export var speed: float = 1.0

var totalTime: float = 0.0
var direction: int = 1
var beginPosition: Vector2

func _ready() -> void:
	var randColor = colors.pick_random()
	beginPosition = global_position
	self_modulate = randColor
	trailChild.self_modulate = randColor
	trailChild.self_modulate.a = 0.5

func _process(delta: float) -> void:
	if position.x > get_viewport().get_visible_rect().size.x + 100:
		queue_free()
	position.y = beginPosition.y + (sin(totalTime*waveFreq) * waveAmp)
	position.x += delta * speed
	rotation_degrees += delta*speed
	totalTime += delta
