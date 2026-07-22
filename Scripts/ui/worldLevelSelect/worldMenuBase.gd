extends Panel
class_name worldMenuBase

@export var levelButtons: Array[levelSelectButton]
@export var levelLabel: Label
@export var worldProgressBar:ProgressBar

var worldResource:levelWorld

@warning_ignore("unused_signal")
signal introTweenComplete
signal showLevelLabel(levelStr:String)
signal updateProgressBar(val:float)

func _ready() -> void:
	showLevelLabel.connect(updLevelLabel)
	updateProgressBar.connect(updProgressBar)
	if levelLabel:
		levelLabel.text = ""

func updLevelLabel(levelStr):
	levelLabel.text = levelStr
func updProgressBar(val:float):
	worldProgressBar.value += val
