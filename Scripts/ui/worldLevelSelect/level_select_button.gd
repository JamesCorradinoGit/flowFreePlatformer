extends Button
class_name levelSelectButton

@export var locked: bool = false
@export var levelLockParam: levelSelectButton
@export var levelToSwitch: PackedScene
@export var lockJettisonPositionCurve: Curve

@onready var lockIcon: TextureButton = $lockIcon
@onready var lockAnimations: AnimationPlayer = $lockAnimations

var ownerMenuPanel: worldMenuBase

#CONNECT SIGNALS

func _ready() -> void:
	lockLevel()
	if self.locked == false or checkIfLevelGlobalUnlocked(self.levelToSwitch):
		unlockLevel(false)
	elif levelLockParam != null:
		var tempLevelLockScene = levelLockParam.levelToSwitch.instantiate()
		if checkIfLevelGlobalCompleted(tempLevelLockScene.name):
			if owner is worldMenuBase:
				lockAnimations.play("unlockIdle")
				await owner.introTweenComplete
				if Globals.unlockedButtonLevels.find(self.levelToSwitch) == -1:
					Globals.unlockedButtonLevels.append(self.levelToSwitch)
					unlockLevel(true)
	if owner is worldMenuBase:
		ownerMenuPanel = owner

func lockLevel():
	lockIcon.visible = true
	self.disabled = true
func unlockLevel(newUnlock: bool):
	if newUnlock: #TODO make unlock animation
		await lockIcon.pressed
		lockAnimations.play("unlockClick")
		await lockAnimations.animation_finished
		await jettisonLock(100)
	lockIcon.visible = false
	self.disabled = false
	self.locked = false

func checkIfLevelGlobalCompleted(levelName:String) -> bool:
	if Globals.completedLevels.find(levelName) != -1:
		return true
	return false
func checkIfLevelGlobalUnlocked(levelName:PackedScene) -> bool:
	if Globals.unlockedButtonLevels.find(levelName) != -1:
		return true
	return false

func _on_pressed() -> void:
	if self.locked == false:
		GlobalSceneLoader.loadScene(str(levelToSwitch.resource_path))

func _on_mouse_entered() -> void:
	if self.locked == false:
		var levelInstTest:level = levelToSwitch.instantiate()
		ownerMenuPanel.showLevelLabel.emit(levelInstTest.lvlName)
		levelInstTest.queue_free()

func _on_mouse_exited() -> void:
	if ownerMenuPanel != null:
		ownerMenuPanel.showLevelLabel.emit("")

#region lock icon stuff
func _on_lock_icon_pressed() -> void:
	lockAnimations.play("lockJiggle")

func _on_lock_icon_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(lockIcon, "scale", Vector2(1.15, 1.15), 0.05)

func _on_lock_icon_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(lockIcon, "scale", Vector2(1, 1), 0.05)

func jettisonLock(strength: float):
	if lockJettisonPositionCurve:
		lockIcon.disabled = true
		var tween = create_tween()
		tween.tween_property(lockIcon, "self_modulate:a", 0, lockJettisonPositionCurve.max_domain / 1.5)
		var randAmp = 5
		var randXDir = randf_range(-1, 1) * randAmp
		var timer:SceneTreeTimer = get_tree().create_timer(lockJettisonPositionCurve.max_domain)
		while timer.time_left > 0.0:
			var curveTime = lockJettisonPositionCurve.max_domain - timer.time_left
			lockIcon.position.y = -(lockJettisonPositionCurve.sample(curveTime) * strength)
			lockIcon.position.x = (curveTime * strength) * randXDir
			lockIcon.rotation += randXDir / randAmp
			await get_tree().process_frame
#endregion
