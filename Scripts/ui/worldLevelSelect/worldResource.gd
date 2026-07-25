extends Resource
class_name levelWorld

@export var worldName:String
@export var worldCompleted:bool = false
@export var levelsResource: Array[levelResource]

func checkIfWorldCompleted():
	if worldCompleted == false:
		for lvl in levelsResource:
			if lvl.completed == false:
				return false
		worldCompleted = true
		return true
