extends Node2D
class_name level

@export var playerSpawn:Marker2D
@export var goalPortal:levelPortal
@export var resetTileset:TileMapLayer
@export var hasGrids:bool = true

var player:PackedScene = load("uid://cvslsain1kjbi")
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
	if self.hasGrids and self.find_child("grids") != null:
		for grid:gridObject in self.find_child("grids").get_children():
			numGrids += 1
			grid.gridCompletedSig.connect(gridComplete)
			grid.gridCompleteBreakSig.connect(gridBreak)

func _process(_delta: float) -> void:
	if gridsComplete and portalInteracted:
		completeLevel.emit()
		set_process(false)

func gridComplete():
	instGridsCompleted += 1
	if self.hasGrids and instGridsCompleted == numGrids:
		print("grids done")
		gridsComplete = true
func gridBreak():
	instGridsCompleted -= 1
	print("grid break")
	gridsComplete = false

func onPortalReached():
	print("done")
	portalInteracted = true
