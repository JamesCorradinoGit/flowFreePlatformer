@tool
extends Node2D

@export var gridNode:PackedScene
@export var gridSizeX:int = 1
@export var gridSizeY:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gNode = gridNode.instantiate()
	var instPosX:int = 0
	var instPosY:int = 0
	for r in range(gridSizeY):
		for c in range(gridSizeX):
			var instGNode = gNode.duplicate()
			instGNode.position = Vector2(instPosX, instPosY)
			add_child(instGNode)
			instPosX += Globals.globalSnap
		instPosX = 0
		instPosY += Globals.globalSnap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _draw() -> void:
	pass
