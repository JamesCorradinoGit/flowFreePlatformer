extends Button
class_name levelSelectButton

@export var levelResourceRef:levelResource
@export var startUnlocked: bool = false
@export var locked: bool = false
@export var levelLockParam: levelSelectButton
@export var lockJettisonPositionCurve: Curve

@onready var lockIcon: TextureButton = $lockIcon
@onready var lockAnimations: AnimationPlayer = $lockAnimations

var ownerMenuPanel:worldMenuBase
var doLockBasePressedState:bool = true

signal levelUnlocked

func _ready() -> void:
	if ownerMenuPanel == null:
		ownerMenuPanel = owner
	lockLevel()
	if self.startUnlocked or self.locked == false or levelResourceRef.unlocked:
		unlockLevel(false)
	elif levelLockParam != null:
		if levelLockParam.levelResourceRef.completed == true:
			if ownerMenuPanel:
				await ownerMenuPanel.introTweenComplete #comment this for instant debug unlock test
				if levelResourceRef.unlocked == false:
					unlockLevel(true)
	
	if levelResourceRef.completed:
		if ownerMenuPanel is worldAutoMenu:
			await ownerMenuPanel.levelButtonsLoaded
		@warning_ignore("integer_division")
		ownerMenuPanel.updProgressBar(100/ownerMenuPanel.levelButtons.size())

func lockLevel():
	lockIcon.visible = true
	self.disabled = true
func unlockLevel(newUnlock: bool):
	doLockBasePressedState = false
	lockAnimations.play("unlockIdle")
	if newUnlock and levelResourceRef.unlocked == false:
		await lockIcon.pressed
		GlobalAudioManager.playGlobalSFX("uid://djei0iy7gunye", 3.0, randf_range(-0.25, 0.25)) #lock jiggle sfx
		levelResourceRef.unlocked = true
		lockAnimations.play("unlockClick")
		await lockAnimations.animation_finished
		GlobalAudioManager.playGlobalSFX("uid://cura2dyhxdgw", 3.0, randf_range(-0.25, 0.25)) #lock explo sfx
		await jettisonLock(100)
	if levelResourceRef.unlocked == false:
		levelResourceRef.unlocked = true
	lockIcon.visible = false
	self.disabled = false
	self.locked = false

func _on_pressed() -> void:
	if self.locked == false:
		GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx
		GlobalSceneLoader.loadScene(str(levelResourceRef.levelScene.resource_path))
		GlobalAudioManager.fadeOutMusicRemove(0.25)
		Globals.currentLvlResource = levelResourceRef
		Globals.currentWorldResource = ownerMenuPanel.worldResource

func _on_mouse_entered() -> void:
	if self.locked == false:
		GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
		ownerMenuPanel.showLevelLabel.emit(levelResourceRef.levelName)

func _on_mouse_exited() -> void:
	if ownerMenuPanel != null:
		ownerMenuPanel.showLevelLabel.emit("")

#region lock icon stuff
func _on_lock_icon_pressed() -> void:
	if doLockBasePressedState and lockAnimations.is_playing() == false:
		lockAnimations.play("lockJiggle")
		GlobalAudioManager.playGlobalSFX("uid://djei0iy7gunye", 3.0, randf_range(-0.25, 0.25)) #lock jiggle sfx

func _on_lock_icon_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
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
	levelUnlocked.emit()
#endregion
