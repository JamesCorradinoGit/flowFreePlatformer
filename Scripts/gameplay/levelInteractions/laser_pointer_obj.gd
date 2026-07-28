@tool
extends Sprite2D
class_name laserPoinerObj

@export var lineColor: Color = Color.WHITE
@export var isEmitting:bool = false
@export var maxLength: int = 1000
@export var maxBounces:int = 3

@onready var laserRay: RayCast2D = $laserRay
@onready var laserLine: Line2D = $laserLine
@onready var poinerLightSprite: Sprite2D = $poinerLightSprite
@onready var bottomEnergyColor: Sprite2D = $bottomEnergyColor

var recentLaserConnection:laserPoinerReciever = null
var currentlyConnected:bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	laserLine.self_modulate = lineColor
	poinerLightSprite.self_modulate = lineColor
	bottomEnergyColor.self_modulate = lineColor

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	if isEmitting:
		if poinerLightSprite.visible == false:
			poinerLightSprite.visible = true
		
		laserLine.clear_points()
		laserLine.add_point(Vector2.ZERO)
		
		laserRay.global_position = laserLine.global_position
		laserRay.target_position = Vector2.UP.normalized() * maxLength
		laserRay.force_raycast_update()
		
		var prev = null
		var localBounces = 0
		
		while true:
			if not laserRay.is_colliding():
				var linePoint = laserRay.global_position + laserRay.target_position
				laserLine.add_point(laserLine.to_local(linePoint).rotated(rotation))
				if currentlyConnected:
					currentlyConnected = false
				break
			
			var collision = laserRay.get_collider() #obj collided with
			var point = laserRay.get_collision_point() #collision coord of bounce
			
			laserLine.add_point(laserLine.to_local(point))
			
			if collision is laserPoinerReciever:
				var pointRec:laserPoinerReciever = collision
				if pointRec.colorToRecieve == self.lineColor:
					if pointRec.isConnected == false:
						currentlyConnected = true
						recentLaserConnection = pointRec
						pointRec.isConnected = true
						pointRec.laserConnect.emit()
				break
			if collision is not laserPoinerReciever and recentLaserConnection and currentlyConnected:
				recentLaserConnection.laserDisconnect.emit()
				recentLaserConnection = null
				currentlyConnected = false
				break
				
			if not collision.is_in_group("laserPointerReflect"):
				break
			
			#normal off of wall w/o rotation
			var rayNormal = laserRay.get_collision_normal()
			if rayNormal == Vector2.ZERO:
				break
			
			#checks and solves improper bouncing
			if prev != null:
				prev.collision_mask = 3
				prev.collision_layer = 3
			prev = collision
			prev.collision_mask = 0
			prev.collision_layer = 0
			
			#updates raycast point
			laserRay.global_position = point
			laserRay.target_position = laserRay.target_position.bounce(rayNormal).rotated(-rotation*2)
			laserRay.force_raycast_update()
			
			localBounces += 1
			if localBounces >= maxBounces:
				break
		if prev != null:
				prev.collision_mask = 3
				prev.collision_layer = 3
		if recentLaserConnection and !currentlyConnected:
			recentLaserConnection.laserDisconnect.emit()
			recentLaserConnection = null
	else:
		if poinerLightSprite.visible == true:
			poinerLightSprite.visible = false
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, Vector2(0, -100), Color.WHITE)
