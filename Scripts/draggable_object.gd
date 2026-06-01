extends Sprite2D

@export var snap:int = 50
@export var allowSlopes:bool = false
@onready var connectLine = $connectJoint
@onready var endButton = $dragButton

var dragging: bool = false

func _on_button_button_down() -> void:
	dragging = true

func _on_button_button_up() -> void:
	dragging = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and dragging:
		checkLinePoints(event)

func checkLinePoints(_event: InputEvent):
	var newPos = get_local_mouse_position()
	var newSnapPos = Vector2(snapped(newPos.x, snap), snapped(newPos.y, snap))
	var intersect:bool = false
	var intersectCutoff = connectLine.get_point_count()
	var slopeFound:bool = false
	
	for i in range(connectLine.get_point_count()):
		if connectLine.get_point_position(i).is_equal_approx(newSnapPos) and intersect == false:
			intersect = true
		if intersect:
			intersectCutoff = i
			break
	if intersect:
		for i in range(connectLine.get_point_count()-1, intersectCutoff, -1):
			connectLine.remove_point(i)
			endButton.position = connectLine.get_point_position(connectLine.get_point_count()-1) - (endButton.size/2)
	else:
		if connectLine.get_point_count() > 0 and allowSlopes == false:
			slopeFound = checkSlopes(newSnapPos) #returns false if no slopes are found
		if slopeFound:
			var adjustPosDist:Vector2 = newSnapPos - get_local_mouse_position()
			print(adjustPosDist)
			if abs(adjustPosDist.x) > abs(adjustPosDist.y):
				connectLine.add_point(Vector2(newSnapPos.x + (snap*(get_global_mouse_position().x/abs(get_global_mouse_position().x))), newSnapPos.y))
			else:
				connectLine.add_point(Vector2(newSnapPos.x, newSnapPos.y + (snap*(get_global_mouse_position().y/abs(get_global_mouse_position().y)))))
		else:
			connectLine.add_point(newSnapPos) #TODO make slopeFound logic
		endButton.position = connectLine.get_point_position(connectLine.get_point_count()-1) - (endButton.size/2)

func checkSlopes(newPoint:Vector2) -> bool:
	if newPoint.x != connectLine.get_point_position(connectLine.get_point_count()-1).x and newPoint.y != connectLine.get_point_position(connectLine.get_point_count()-1).y:
		return true
	return false
