extends Sprite2D

var deathTiles = get_parent()

func _on_void_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.isRespawning == false:
		body.isRespawning = true
		body.triggerRespawn.emit()
