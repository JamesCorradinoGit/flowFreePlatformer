extends Node2D
class_name gridObject

@export var gridNode:PackedScene
@export var gridSizeX:int = 1
@export var gridSizeY:int = 1
@export var gridBorder:PackedScene
@export var gridModifiers:Array[gridModifier]

@onready var totalGridPosX = global_position.x + (Globals.globalSnap * self.gridSizeX)
@onready var totalGridPosY = global_position.y + (Globals.globalSnap * self.gridSizeY)
@onready var totalCells = self.gridSizeX*self.gridSizeY
@onready var lineNodeTscn:PackedScene = load("uid://ccugvwenhhjgr")
@onready var flowLinesVar: Node = $flowLines

var cellNumsToModify:Array[int] = []
var linesToFill:int = 0
var currentFilledLines:int = 0
var gridCompleted:bool = false

signal gridCompletedSig
signal gridCompleteBreakSig

func _ready() -> void:
	for mod:gridModifier in gridModifiers:
		if mod.cellToModify <= totalCells:
			cellNumsToModify.append(mod.cellToModify)
	var gNode = gridNode.instantiate()
	var instPosX:int = 0
	var instPosY:int = 0
	var ind = 1
	var maxGridIndexX = gridSizeX-1
	var maxGridIndexY = gridSizeY-1
	for r in range(gridSizeY):
		for c in range(gridSizeX):
			var instGNode = gNode.duplicate()
			instGNode.name = "gridNode"+str(ind)
			if cellNumsToModify.find(ind) != -1:
				var modIndex = self.gridModifiers[cellNumsToModify.find(ind)]
				if modIndex.leftModify != null:
					instGNode.leftObstacle = modIndex.leftModify
				if modIndex.rightModify != null:
					instGNode.rightObstacle = modIndex.rightModify
				if modIndex.topModify != null:
					instGNode.topObstacle = modIndex.topModify
				if modIndex.bottomModify != null:
					instGNode.bottomObstacle = modIndex.bottomModify
				if modIndex.lineNodeAdd != null:
					var line:lineNodeKB = lineNodeTscn.instantiate().duplicate()
					line.lineColor = modIndex.lineNodeAdd.color
					line.reciever = modIndex.lineNodeAdd.reciver
					instGNode.addedLine = line
				elif modIndex.middleCellModify != null: #TODO implement
					print("middle priority")
			match c:
				0:
					instGNode.leftObstacle = gridBorder
				maxGridIndexX:
					instGNode.rightObstacle = gridBorder
			instGNode.position = Vector2(instPosX, instPosY)
			if r == 0:
				instGNode.topObstacle = gridBorder
			if r == maxGridIndexY:
				instGNode.bottomObstacle = gridBorder
			add_child(instGNode)
			instPosX += Globals.globalSnap
			ind+=1
		instPosX = 0
		instPosY += Globals.globalSnap
	@warning_ignore("integer_division")
	linesToFill = flowLinesVar.get_child_count()/2
	for line:lineNodeKB in flowLinesVar.get_children():
		if line.reciever == false:
			line.connect("connectSuccess", onLineConnect)
			line.connect("connectBreak", onLineDisconnect)

func onLineConnect():
	currentFilledLines += 1
	if currentFilledLines == linesToFill:
		gridCompleted = true
		self.gridCompletedSig.emit()
func onLineDisconnect():
	currentFilledLines -= 1
	if currentFilledLines == linesToFill - 1:
		gridCompleted = false
		self.gridCompleteBreakSig.emit()

func disableGrid():
	for line:lineNodeKB in flowLinesVar.get_children():
		line.endButton.disabled = true
		if line.dragging == true:
			line.forceSubmitLine.emit()
