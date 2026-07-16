@tool
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
var levelParent: level

signal gridCompletedSig
signal gridCompleteBreakSig

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if owner is level: #assign level parent var
		levelParent = owner
	for mod:gridModifier in gridModifiers: #grid modifiers
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
			var instGNode:gridSpace = gNode.duplicate()
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
				if modIndex.lineNodeAdd != null: #check if there is a conduit node
					var line:lineNodeKB = lineNodeTscn.instantiate().duplicate()
					line.lineColor = modIndex.lineNodeAdd.color
					line.reciever = modIndex.lineNodeAdd.reciver
					instGNode.addedLine = line
				elif modIndex.middleCellModify != null: #TODO implement
					if modIndex.middleCellModify is gridMiddleModifierObject:
						instGNode.middleNode = modIndex.middleCellModify.instanceGridObject()
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

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
func _draw() -> void:
	@warning_ignore_start("integer_division")
	if Engine.is_editor_hint():
		var halfGlobalSnap = Globals.globalSnap / 2
		var startingLinePos = halfGlobalSnap
		draw_rect(Rect2(Vector2i(-Globals.globalSnap/2, -Globals.globalSnap/2), Vector2i(Globals.globalSnap * self.gridSizeX, Globals.globalSnap * self.gridSizeY)), Color.WHITE, false)
		for x in range(self.gridSizeX - 1):
			draw_line(Vector2(startingLinePos, -halfGlobalSnap), Vector2(startingLinePos, (self.gridSizeY * Globals.globalSnap)-halfGlobalSnap), Color.RED)
			startingLinePos += Globals.globalSnap
		startingLinePos = halfGlobalSnap
		for y in range(self.gridSizeY - 1):
			draw_line(Vector2(-halfGlobalSnap, startingLinePos), Vector2((self.gridSizeX * Globals.globalSnap)-halfGlobalSnap, startingLinePos), Color.ORANGE)
			startingLinePos += Globals.globalSnap

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
