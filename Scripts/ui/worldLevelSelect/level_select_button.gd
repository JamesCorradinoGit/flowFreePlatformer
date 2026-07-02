extends Button
class_name levelSelectButton

@export var locked: bool = false
@export var levelLockParam: levelSelectButton
@export var levelToSwitch: PackedScene

@onready var lockIcon: TextureRect = $lockIcon

func _ready() -> void:
	lockLevel()
	if self.locked == false or checkIfLevelGlobalUnlocked(self.levelToSwitch):
		unlockLevel(false)
	elif levelLockParam != null:
		var tempLevelLockScene = levelLockParam.levelToSwitch.instantiate()
		if checkIfLevelGlobalCompleted(tempLevelLockScene.name):
			if owner is worldMenuBase:
				await owner.introTweenComplete
				if Globals.unlockedButtonLevels.find(self.levelToSwitch) == -1:
					Globals.unlockedButtonLevels.append(self.levelToSwitch)
					unlockLevel(true)

func lockLevel():
	lockIcon.visible = true
	self.disabled = true
func unlockLevel(newUnlock: bool):
	if newUnlock: #TODO make unlock animation
		print("new")
	lockIcon.visible = false
	self.disabled = false

func checkIfLevelGlobalCompleted(levelName:String) -> bool:
	if Globals.completedLevels.find(levelName) != -1:
		return true
	return false
func checkIfLevelGlobalUnlocked(levelName:PackedScene) -> bool:
	if Globals.unlockedButtonLevels.find(levelName) != -1:
		return true
	return false

func _on_pressed() -> void:
	GlobalSceneLoader.loadScene(str(levelToSwitch.resource_path))
