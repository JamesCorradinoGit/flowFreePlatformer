extends CanvasLayer

@onready var staticRect: ColorRect = $staticRect
@onready var rogueIcon: TextureRect = $rogueIcon
@onready var bgRect: ColorRect = $bgRect

var canvasTween:Tween

signal tweenDoneToQueue

func _ready() -> void:
	staticRect.material = staticRect.material.duplicate()
	
	canvasTween = create_tween()
	canvasTween.set_parallel()
	canvasTween.tween_method(shiftStaticAmount, 0.0, 0.75, 2.0)
	canvasTween.tween_property(bgRect, "self_modulate:a", 1.0, 2.0)
	await canvasTween.finished
	canvasTween.kill()
	
	canvasTween = create_tween()
	canvasTween.tween_property(rogueIcon, "self_modulate:a", 1.0, 1.0)
	await canvasTween.finished
	await get_tree().create_timer(2).timeout
	canvasTween.kill()
	
	canvasTween = create_tween()
	canvasTween.set_parallel()
	canvasTween.tween_property(rogueIcon, "self_modulate:a", 0.0, 1.0)
	canvasTween.tween_method(shiftStaticAmount, 0.75, 0.0, 1.5)
	canvasTween.tween_property(bgRect, "self_modulate:a", 0.0, 1.5)
	await canvasTween.finished
	
	tweenDoneToQueue.emit()

func shiftStaticAmount(val:float):
	staticRect.material.set_shader_parameter("amount", val)
