@tool
extends Node2D
class_name gridObject

@export var gridNode:PackedScene
@export var gridSizeX:int = 1
@export var gridSizeY:int = 1
@export var gridBorder:PackedScene

@onready var totalGridPosX = global_position.x + (Globals.globalSnap * self.gridSizeX)
@onready var totalGridPosY = global_position.y + (Globals.globalSnap * self.gridSizeY)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gNode = gridNode.instantiate()
	var instPosX:int = 0
	var instPosY:int = 0
	var maxGridIndexX = gridSizeX-1
	var maxGridIndexY = gridSizeY-1
	for r in range(gridSizeY):
		for c in range(gridSizeX):
			var instGNode = gNode.duplicate()
			match c:
				0:
					instGNode.leftObstacle = gridBorder
				maxGridIndexX:
					instGNode.rightObstacle = gridBorder
			instGNode.position = Vector2(instPosX, instPosY)
			match r:
				0:
					instGNode.topObstacle = gridBorder
				maxGridIndexY:
					instGNode.bottomObstacle = gridBorder
			add_child(instGNode)
			instPosX += Globals.globalSnap
		instPosX = 0
		instPosY += Globals.globalSnap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
