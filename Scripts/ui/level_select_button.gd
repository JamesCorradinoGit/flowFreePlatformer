extends Button

@export var locked: bool = false
@onready var lockIcon: TextureRect = $lockIcon
@export var levelLockParam: PackedScene
@export var levelToSwitch: PackedScene

func _ready() -> void:
	if self.locked:
		lockLevel()
	else:
		unlockLevel()

func lockLevel():
	lockIcon.visible = true
	self.disabled = true

func unlockLevel():
	lockIcon.visible = false
	self.disabled = false

func _on_pressed() -> void:
	GlobalSceneLoader.loadScene(str(levelToSwitch.resource_path))
