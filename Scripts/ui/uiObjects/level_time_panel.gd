extends Panel
class_name levelTimePanel

@export var newHighscore:bool = false
@export var totalTimeInSec:float
@export var completeScreen:endScreen

@onready var timeLabel: Label = $timeLabel
@onready var flairLabel: Label = $flairLabel
@onready var highscoreLabel: Label = $highscoreLabel

var minutesTime:int
var secondsTime:int

func _ready() -> void:
	material = material.duplicate()
	completeScreen.updateTimeLabel.connect(recieveNewTimeInfo)
	await completeScreen.updateTimeLabel
	if newHighscore:
		timeLabel.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 1.0))
		flairLabel.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 1.0))
		highscoreLabel.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 1.0))
		material.set_shader_parameter("isEffectVisible", true)
		highscoreLabel.text = "NEW HIGHSCORE!"
	else:
		highscoreLabel.text = "Beat " + calculateTimeAsString(Globals.currentLvlResource.bestTimeInSec) + " for a new highscore!"
	timeLabel.text = calculateTimeAsString(totalTimeInSec)
func recieveNewTimeInfo(hs:bool, time:float):
	self.newHighscore = hs
	self.totalTimeInSec = time
func calculateTimeAsString(time:float) -> String:
	var tString:String = ""
	minutesTime = floor(time / 60)
	@warning_ignore("narrowing_conversion")
	secondsTime = time - (60*minutesTime)
	tString = str(minutesTime)+":"
	
	if secondsTime >= 1 and secondsTime <= 9:
		tString += "0" + str(secondsTime)
	elif secondsTime == 0:
		tString += "00"
	else:
		tString += str(secondsTime)
	
	return tString
