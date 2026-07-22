extends Resource
class_name levelWorld

@export var worldName:String
@export var levels: Array[PackedScene]
@export var levelsResource: Array[levelResource]

func verifyLevels() -> bool:
	for levelComp in levels:
		var instLevelComp = levelComp.instantiate()
		if instLevelComp is not level:
			return false
		instLevelComp.queue_free()
	return true
