extends Node2D
class_name level

@export var playerSpawn:Marker2D
@export var goalPortal:levelPortal
@export var resetTileset:TileMapLayer
@export var groundTileset:TileMapLayer
@export var hasGrids:bool = true
@export var gridParent:Node
@export_category("Level Details")
#@export var worldName:String = ""
#@export var lvlName:String = ""
@export var lvlSongDictionaryKey:String = ""
@export_category("Popup Starters")
@export var startWithPopup:bool = false
@export var startingPopupName:String
@export_multiline() var startingPopupMessage:String
@export var startingPopupDuration:float = 5.0

var player:PackedScene = load("uid://cvslsain1kjbi")
var endScreenS:PackedScene = load("uid://lr2vwnf35d5u")
var levelBG:PackedScene = load("uid://cb8b1y5gccm1m")
var pauseMenuInst:PackedScene = load("uid://0jki0fjckxxy")
var numGrids:int = 0
var instGridsCompleted:int = 0

var pauseMenuVisible: bool = false
var canPause:bool = true
var activePauseMenu: Control

var gridsComplete:bool = false
var portalInteracted:bool = false

@warning_ignore("unused_signal")
signal completeLevel
signal updateGroundColors(colorChange: Color)

func _ready() -> void:
	if groundTileset.material:
		groundTileset.material = groundTileset.material.duplicate()
	else:
		push_warning("No ground tileset material")
	
	goalPortal.goalReached.connect(onPortalReached)
	updateGroundColors.connect(changeGroundColors)
	
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
	add_child(levelBG.instantiate())
	
	if self.lvlSongDictionaryKey != "" and GlobalAudioManager.songList.has(self.lvlSongDictionaryKey) and GlobalAudioManager.activeSong == null:
		GlobalAudioManager.playMusic(GlobalAudioManager.songList[lvlSongDictionaryKey], -12.0)
	else:
		push_warning("No song loaded in level")
	
	if self.startWithPopup:
		GlobalPopup.showMessage(self.startingPopupName, self.startingPopupMessage, self.startingPopupDuration, self)
func _process(_delta: float) -> void:
	if gridsComplete and portalInteracted:
		onAllCompleted()
		completeLevel.emit()
		set_process(false)

func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("uiBack") and pauseMenuVisible == false and canPause:
		pauseMenuVisible = true
		var localPauseMenuInst:pauseMenu = pauseMenuInst.instantiate()
		localPauseMenuInst.hidePauseMenu.connect(pauseMenuHidden)
		localPauseMenuInst.global_position = Vector2.ZERO
		localPauseMenuInst.levelOwner = self
		add_child(localPauseMenuInst)
		activePauseMenu = localPauseMenuInst
func pauseMenuHidden():
	pauseMenuVisible = false
	activePauseMenu = null
func onLevelExit():
	Globals.isAlreadyDragging = false
	Globals.currentLvlResource = null
	Globals.currentWorldResource = null
func onLevelRestart():
	Globals.isAlreadyDragging = false

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
	canPause = false
	if self.hasGrids:
		disableAllGrids()
	if Globals.currentLvlResource.completed == false:
		Globals.currentLvlResource.completed = true
	var endInst:endScreen = endScreenS.instantiate()
	endInst.instLevelName = Globals.currentLvlResource.levelName
	endInst.instWorldName = Globals.currentWorldResource.worldName
	endInst.levelOwner = self
	endInst.position = Vector2.ZERO
	add_child(endInst)

func changeGroundColors(colorChange:Color):
	groundTileset.material.set_shader_parameter("newColor", colorChange)
