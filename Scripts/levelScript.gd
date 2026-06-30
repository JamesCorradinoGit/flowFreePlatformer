extends Node2D
class_name level

@export var playerSpawn:Marker2D
@export var goalPortal:levelPortal
@export var resetTileset:TileMapLayer
@export var hasGrids:bool = true
@export var gridParent:Node
@export_category("Level Details")
@export var worldName:String = ""
@export var lvlName:String = ""

var player:PackedScene = load("uid://cvslsain1kjbi")
var endScreenS:PackedScene = load("uid://lr2vwnf35d5u")
var numGrids:int = 0
var instGridsCompleted:int = 0

var gridsComplete:bool = false
var portalInteracted:bool = false

@warning_ignore("unused_signal")
signal completeLevel

func _ready() -> void:
	goalPortal.goalReached.connect(onPortalReached)
	var tempPlayer:CharacterBody2D = player.instantiate().duplicate()
	tempPlayer.global_position = playerSpawn.global_position
	add_child(tempPlayer)
	if self.hasGrids and self.gridParent != null:
		for grid:gridObject in self.gridParent.get_children():
			numGrids += 1
			grid.gridCompletedSig.connect(gridComplete)
			grid.gridCompleteBreakSig.connect(gridBreak)
	else:
		gridsComplete = true

func _process(_delta: float) -> void:
	if gridsComplete and portalInteracted:
		onAllCompleted()
		completeLevel.emit()
		set_process(false)

func gridComplete():
	instGridsCompleted += 1
	if self.hasGrids and instGridsCompleted == numGrids:
		gridsComplete = true
func gridBreak():
	instGridsCompleted -= 1
	gridsComplete = false
func disableAllGrids():
	for grid:gridObject in self.gridParent.get_children():
		grid.disableGrid()

func onPortalReached():
	portalInteracted = true

func onAllCompleted():
	if self.hasGrids:
		disableAllGrids()
	if Globals.completedLevels.find(self.name) == -1:
		Globals.completedLevels.append(self.name)
		print(Globals.completedLevels)
	var endInst:endScreen = endScreenS.instantiate()
	endInst.instLevelName = self.lvlName
	endInst.instWorldName = self.worldName
	endInst.position = Vector2.ZERO
	add_child(endInst)
