extends Node

signal progressChanged(progress)
signal loadFinished

var loadingScreen: PackedScene = preload("uid://rsxedg372pwf")
var loadedResource: PackedScene
var scenePath: String
var progress: Array = []
var useSubThreads: bool = true

func _ready() -> void:
	set_process(false)

func loadScene(_scenePath: String) -> void: #add ways to get send multiple different transitions
	scenePath = _scenePath
	
	var newLoadScreen:LoadingScreen = loadingScreen.instantiate()
	add_child(newLoadScreen)
	progressChanged.connect(newLoadScreen.onProgressChanged)
	loadFinished.connect(newLoadScreen.onLoadFinished)
	
	await newLoadScreen.loadingScreenReady
	
	startLoad()

func startLoad() -> void:
	var state = ResourceLoader.load_threaded_request(scenePath, "", useSubThreads)
	if state == OK:
		set_process(true)

func _process(_delta: float) -> void:
	var loadStatus = ResourceLoader.load_threaded_get_status(scenePath, progress)
	progressChanged.emit(progress[0])
	match loadStatus:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loadedResource = ResourceLoader.load_threaded_get(scenePath)
			get_tree().change_scene_to_packed(loadedResource)
			loadFinished.emit()
