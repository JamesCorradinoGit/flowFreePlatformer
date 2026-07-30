extends Node2D
class_name level

@export var playerSpawn:Marker2D
@export var goalPortal:levelPortal
@export var resetTileset:TileMapLayer
@export var groundTileset:TileMapLayer
@export var hasGrids:bool = true
@export var gridParent:Node
@export_category("Level Details")
@export var lvlSongDictionaryKey:String = ""
@export var darkLevel:bool = false
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
var instGridsCompleted:int

var nodeGroupNames = [
	"grids",
	"interactables"
]
var lightSprite = load("uid://dlvbfage45w5e")

var countTime:bool = true
var timeInLevel:float = 0.0

var pauseMenuVisible: bool = false
var canPause:bool = true
var activePauseMenu: Control

var gridsComplete:bool = false
var portalInteracted:bool = false

@warning_ignore("unused_signal")
signal completeLevel
signal updateGroundColors(colorChange: Color)
signal gridsCompletedUpdate(amount: int)

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
	elif self.lvlSongDictionaryKey == "":
		push_warning("No song loaded in level")
	
	if self.startWithPopup:
		GlobalPopup.showMessage(self.startingPopupName, self.startingPopupMessage, self.startingPopupDuration, self)
	
	if self.darkLevel == true:
		makeLevelDark()
func _process(delta: float) -> void:
	if countTime:
		timeInLevel += delta
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

func makeLevelDark():
	var cnvsMod = CanvasModulate.new()
	cnvsMod.color = Color(0.051, 0.051, 0.051)
	add_child(cnvsMod)
	
	for c in get_children():
		if c.name in nodeGroupNames:
			if c.name == "grids":
				for cChildG in c.get_children():
					if cChildG is gridObject:
						var lightScaleX = cChildG.gridSizeX + 4
						var lightScaleY = cChildG.gridSizeY + 4
						
						var instLight = PointLight2D.new()
						instLight.texture = lightSprite
						instLight.blend_mode = Light2D.BLEND_MODE_MIX
						instLight.scale = Vector2(lightScaleX, lightScaleY)
						instLight.position = Vector2(((cChildG.gridSizeX*Globals.globalSnap)/2)-16, 
							((cChildG.gridSizeY*Globals.globalSnap)/2)-16)
						cChildG.add_child(instLight)
						continue
			if c.name == "interactables":
				for cChildI in c.get_children():
					addLight(cChildI)
		addLight(c)
		
func addLight(c:Node):
	if c.has_meta("lightLevelScale") and c.get_meta("lightLevelScale") is Vector2:
			var instLight = PointLight2D.new()
			instLight.texture = lightSprite
			instLight.blend_mode = Light2D.BLEND_MODE_MIX
			instLight.scale  = c.get_meta("lightLevelScale")
			if c is mechanismDoor:
				instLight.position = c.directionSprite.position
			c.add_child(instLight)

func gridComplete():
	instGridsCompleted += 1
	gridsCompletedUpdate.emit(instGridsCompleted)
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
	countTime = false
	if self.hasGrids:
		disableAllGrids()
	if Globals.currentLvlResource.completed == false:
		Globals.currentLvlResource.completed = true
	var endInst:endScreen = endScreenS.instantiate()
	endInst.instLevelName = Globals.currentLvlResource.levelName
	endInst.instWorldName = Globals.currentWorldResource.worldName
	endInst.levelOwner = self
	endInst.position = Vector2.ZERO
	if Globals.currentLvlResource.bestTimeInSec == 0.0 or Globals.currentLvlResource.bestTimeInSec > timeInLevel:
		Globals.currentLvlResource.bestTimeInSec = timeInLevel
		endInst.isLevelTimeNewHighScore = true
	endInst.timeToDisplay = timeInLevel
	add_child(endInst)

func changeGroundColors(colorChange:Color):
	groundTileset.material.set_shader_parameter("newColor", colorChange)
