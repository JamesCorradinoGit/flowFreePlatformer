extends Button

@export var locked: bool = false
@onready var lockIcon: TextureRect = $lockIcon

# Called when the node enters the scene tree for the first time.
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
