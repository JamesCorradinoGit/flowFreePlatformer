extends Node

const globalSnap:int = 32

var isAlreadyDragging:bool = false
var selectedLine:Node2D = null
var selectedLineArea:Area2D = null
var levelResources:Array[levelResource] = []

#globals for what level and world the player is in if in one
var currentLvlResource:levelResource
var currentWorldResource:levelWorld

func _ready() -> void:
	loadLevelFiles()

func loadLevelFiles():
	var levelFolderPath = "res://Objects/resources/worldResources/"
	var files = DirAccess.get_files_at(levelFolderPath)
	for f in files:
		var tempFile:levelWorld = ResourceLoader.load(levelFolderPath + f)
		for lvl:levelResource in tempFile.levelsResource:
			levelResources.append(lvl)
