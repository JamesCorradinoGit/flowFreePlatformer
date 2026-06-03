extends Sprite2D

@export_category("Border Obstacles")
@export var leftObstacle:PackedScene
@export var rightObstacle:PackedScene
@export var topObstacle:PackedScene
@export var bottomObstacle:PackedScene
@export var middleNode:PackedScene
@export var addedLine:Sprite2D

@onready var spawnSpot: Marker2D = $spawnSpot

@warning_ignore_start("integer_division")
func _ready() -> void:
	if leftObstacle != null:
		var obstInst = leftObstacle.instantiate().duplicate()
		obstInst.position = Vector2(-Globals.globalSnap/2,0)
		add_child(obstInst)
	if rightObstacle != null:
		var obstInst = rightObstacle.instantiate().duplicate()
		obstInst.position = Vector2(Globals.globalSnap/2,0)
		add_child(obstInst)
	if topObstacle != null:
		var obstInst = topObstacle.instantiate().duplicate()
		obstInst.rotate(PI/2)
		obstInst.position = Vector2(0,-Globals.globalSnap/2)
		add_child(obstInst)
	if bottomObstacle != null:
		var obstInst = bottomObstacle.instantiate().duplicate()
		obstInst.rotate(PI/2)
		obstInst.position = Vector2(0,Globals.globalSnap/2)
		add_child(obstInst)
	if middleNode != null:
		var obstInst = middleNode.instantiate().duplicate()
		obstInst.position = spawnSpot.position
		add_child(obstInst)
	if addedLine != null:
		var obstInst = addedLine
		get_parent().find_child("flowLines").add_child(obstInst)
		obstInst.global_position = self.spawnSpot.global_position
