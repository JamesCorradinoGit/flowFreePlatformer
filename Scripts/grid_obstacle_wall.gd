extends Sprite2D

@onready var obstacleCollision: Area2D = $obstacleCollision

func _on_obstacle_collision_area_entered(area: Area2D) -> void:
	if area.owner is lineNodeKB:
		area.owner.handleIntersect(area.owner.connectLine.get_point_count()-2)
