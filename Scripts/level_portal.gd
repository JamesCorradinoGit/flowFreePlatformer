extends Sprite2D
class_name levelPortal

@export var tweenDuration:float = 1.0

signal goalReached

func _on_portal_collision_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var tween = get_tree().create_tween()
		body.set_physics_process(false)
		
		tween.set_parallel(true)
		tween.tween_property(body, "global_position", global_position, self.tweenDuration)
		tween.tween_property(body, "scale", Vector2.ZERO, self.tweenDuration)
		tween.play()
		await tween.finished
		body.queue_free()
		goalReached.emit()
