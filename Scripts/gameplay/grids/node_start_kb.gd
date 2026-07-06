extends Sprite2D
class_name lineNodeKB

@export var lineColor:Color = Color.WHITE
@export_subgroup("collisions")
@export var lineIntersectCutsOffFullLine:bool = false
@export var cols:Array = []
@export var arCols:Array = []
@export_subgroup("")
@export var reciever:bool
@export var pairNode:Sprite2D

@onready var connectLine = $connectLine
@onready var endButton = $kbDragButton
@onready var colBody: StaticBody2D = $connectLine/colBody
@onready var colArea: Area2D = $connectLine/colArea
@onready var recieveSprite: Sprite2D = $recieveSprite

var dragging: bool = false
var lineConnected: bool = false
var parentedToGrid:bool = false
const SNAP:int = Globals.globalSnap

@warning_ignore_start("unused_signal")
signal startDrag
signal onDrag
signal submitDrag
signal connectSuccess
signal connectBreak
signal forceSubmitLine

func _ready() -> void:
	forceSubmitLine.connect(submitLine)
	connectLine.default_color = lineColor
	material = material.duplicate()
	material.set_shader_parameter("newColor", lineColor)
	if self.reciever:
		endButton.disabled = true
		endButton.hide()
		recieveSprite.show()
	if get_parent() is gridObject:
		parentedToGrid = true

func _process(_delta: float) -> void:
	if dragging:
		if Input.is_action_just_pressed("moveDown"):
			checkLinePoints("down")
		elif Input.is_action_just_pressed("moveLeft"):
			checkLinePoints("left")
		elif Input.is_action_just_pressed("moveRight"):
			checkLinePoints("right")
		elif Input.is_action_just_pressed("moveUp"):
			checkLinePoints("up")
		elif Input.is_action_just_pressed("moveDone"):
			submitLine()
func submitLine():
	dragging = false
	Globals.isAlreadyDragging = false
	Globals.selectedLine = null
	Globals.selectedLineArea = null
	endButton.release_focus()
	self.submitDrag.emit()

func checkLinePoints(direction:String):
	var intersect:bool = false
	var intersectCutoff = connectLine.get_point_count()
	var changeVert:int = 0
	var changeHori:int = 0
	match direction:
		"up":
			changeVert = -SNAP
		"down":
			changeVert = SNAP
		"left":
			changeHori = -SNAP
		"right":
			changeHori = SNAP
	var newSnapPos = Vector2(connectLine.get_point_position(connectLine.get_point_count()-1).x+changeHori, connectLine.get_point_position(connectLine.get_point_count()-1).y+changeVert)
	var oldPos = connectLine.get_point_position(connectLine.get_point_count()-1)
	"""
	var test = Sprite2D.new()
	test.texture = recieveSprite.texture
	test.global_position = Vector2(newSnapPos.x-(changeHori/2), newSnapPos.y-(changeVert/2)) 
	add_child(test)
	"""
	if self.parentedToGrid:
		if to_global(newSnapPos).x < get_parent().global_position.x or to_global(newSnapPos).x >= get_parent().totalGridPosX:
			return
		if to_global(newSnapPos).y < get_parent().global_position.y or to_global(newSnapPos).y >= get_parent().totalGridPosY:
			return
	@warning_ignore("integer_division")
	if getObstacleNodesAtPoint(to_global(Vector2(newSnapPos.x-(changeHori/2), newSnapPos.y-(changeVert/2)))):
		return
	if !lineConnected:
		for i in range(connectLine.get_point_count()):
			if connectLine.get_point_position(i).is_equal_approx(newSnapPos) and intersect == false:
				intersect = true
			if intersect:
				intersectCutoff = i
				break
		if intersect:
			handleIntersect(intersectCutoff)
		else:
			var otherNodeTest:lineNodeKB = getLineNodesAtPoint(to_global(newSnapPos))
			if otherNodeTest != null and otherNodeTest.lineColor != self.lineColor:
				return
			connectLine.add_point(newSnapPos)
			addCollision(oldPos, newSnapPos)
			self.onDrag.emit()
			endButton.position = connectLine.get_point_position(connectLine.get_point_count()-1) - (endButton.size/2)
	elif lineConnected:
		handleIntersect(connectLine.get_point_count()-2)
		self.connectBreak.emit()
func addCollision(oldPos:Vector2, newPos:Vector2):
	var colBox = CollisionShape2D.new()
	var shape = SegmentShape2D.new()
	shape.a = oldPos
	shape.b = newPos
	colBox.shape = shape
	colBody.add_child(colBox)
	cols.append(colBox)
	
	var arCol = colBox.duplicate()
	arCol.debug_color = Color(0.259, 0.525, 0.38, 0.584)
	colArea.add_child(arCol)
	arCols.append(arCol)
func removeCollision(ind:int):
	var pos = cols[ind]
	var arPos = arCols[ind]
	cols.remove_at(ind)
	arCols.remove_at(ind)
	pos.queue_free()
	arPos.queue_free()
func handleIntersect(index):
	for i in range(connectLine.get_point_count()-1, index, -1):
			connectLine.remove_point(i)
			removeCollision(i)
			endButton.position = connectLine.get_point_position(connectLine.get_point_count()-1) - (endButton.size/2)
func resetLine():
	handleIntersect(0)
func checkClosestPoint(posToCheck:Vector2, lineToCheck, rangeToCheck:int) -> int:
	var index:int = rangeToCheck
	for i in range(rangeToCheck):
		var loopPos = lineToCheck.to_global(lineToCheck.get_point_position(i))
		if loopPos == posToCheck:
			print(loopPos, posToCheck)
			index = i
	return index
func getLineNodesAtPoint(pos:Vector2):
	var world2D = get_world_2d().direct_space_state
	var queryTemp = PhysicsPointQueryParameters2D.new()
	queryTemp.position = pos
	queryTemp.collide_with_areas = true
	queryTemp.collide_with_bodies = true
	
	var resu = world2D.intersect_point(queryTemp)
	if resu != []:
		for result in resu:
			if result["collider"].owner is lineNodeKB:
				return result["collider"].owner
	return null
func getObstacleNodesAtPoint(pos:Vector2):
	var world2D = get_world_2d().direct_space_state
	var queryTemp = PhysicsPointQueryParameters2D.new()
	queryTemp.position = pos
	queryTemp.collide_with_areas = true
	queryTemp.collide_with_bodies = true
	
	var resu = world2D.intersect_point(queryTemp)
	for result in resu:
		if result["collider"].owner == null:
			if result["collider"].is_in_group("flowLineObstacle"):
				return true
		elif result["collider"].owner.is_in_group("flowLineObstacle"):
			return true
	return false

func _on_col_area_area_entered(area: Area2D) -> void:
	if colArea == Globals.selectedLineArea and area.get_parent() is Line2D:
		var areaParent = area.get_parent().get_parent()
		if self.lineIntersectCutsOffFullLine:
			areaParent.resetLine()
		else:
			var intersectPoint = checkClosestPoint(connectLine.to_global(connectLine.get_point_position(connectLine.get_point_count()-1)), areaParent.connectLine, areaParent.connectLine.get_point_count()-1)
			if intersectPoint != 0:
				areaParent.handleIntersect(intersectPoint-1)
				if areaParent.lineConnected:
					areaParent.connectBreak.emit()
			else:
				areaParent.resetLine()

func _on_line_node_collision_area_entered(area: Area2D) -> void:
	if area.name == "colArea" and area.owner != self and self.lineColor == area.owner.lineColor and self.reciever == true:
		area.owner.lineConnected = true
		area.owner.connectSuccess.emit()

func _on_line_node_collision_area_exited(area: Area2D) -> void:
	if area.get_parent() is Line2D:
		area.owner.lineConnected = false
		if area.owner.reciever == true:
			area.owner.endButton.show()
			endButton.show()

func _on_kb_drag_button_pressed() -> void:
	if Globals.isAlreadyDragging == false:
		dragging = true
		Globals.isAlreadyDragging = true
		Globals.selectedLine = self
		Globals.selectedLineArea = colArea
		self.startDrag.emit()
	elif Globals.isAlreadyDragging:
		endButton.release_focus()
