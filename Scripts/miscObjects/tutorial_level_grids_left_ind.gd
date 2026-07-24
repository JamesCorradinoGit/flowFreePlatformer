extends NinePatchRect

@export var levelToMonitor: level

@onready var numLabelDone: Label = $numLabelDone
@onready var numLabelMax: Label = $numLabelMax

func _ready() -> void:
	await get_tree().process_frame
	numLabelMax.text = str(levelToMonitor.numGrids)
	numLabelDone.text = str(0)
	levelToMonitor.gridsCompletedUpdate.connect(updDoneLabel)

func updDoneLabel(val):
	numLabelDone.text = str(val)
