extends Button
class_name levelSelectButton

@export var locked: bool = false
@export var levelLockParam: levelSelectButton
@export var levelToSwitch: PackedScene

@onready var lockIcon: TextureRect = $lockIcon

#signal levelParamComplete

func _ready() -> void:
	if owner is worldMenuBase:
		owner.introTweenComplete.connect(func(): print("hi"))
	if levelLockParam != null:
		var tempLevelLockScene = levelLockParam.levelToSwitch.instantiate()
		if checkIfLevelGlobalCompleted(tempLevelLockScene.name):
			unlockLevel()
		else:
			lockLevel()

func lockLevel():
	lockIcon.visible = true
	self.disabled = true
func unlockLevel():
	lockIcon.visible = false
	self.disabled = false

func checkIfLevelGlobalCompleted(levelName:String) -> bool:
	if Globals.completedLevels.find(levelName) != -1:
		print("level completed")
		return true
	return false

func _on_pressed() -> void:
	GlobalSceneLoader.loadScene(str(levelToSwitch.resource_path))
