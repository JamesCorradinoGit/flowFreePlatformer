extends Panel
class_name worldMenuBase

@export var levelButtons: Array[Button]
@export var levelLabel: Label

@warning_ignore("unused_signal")
signal introTweenComplete
signal showLevelLabel(levelStr:String)

func _ready() -> void:
	showLevelLabel.connect(updLevelLabel)
	if levelLabel:
		levelLabel.text = ""

func updLevelLabel(levelStr):
	levelLabel.text = levelStr
