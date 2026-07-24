extends worldMenuBase
class_name worldAutoMenu

@export var worldToLoad: levelWorld
@export_category("important stuff")
@export var worldNameLabel: Label
@export var levelContainer: GridContainer

var levelButtonRef:PackedScene = load("uid://bexfihknk1j6j")
var loadedLevelButtons:Array[levelSelectButton] = []

signal levelButtonsLoaded

func _ready() -> void:
	showLevelLabel.connect(updLevelLabel)
	updateProgressBar.connect(updProgressBar)
	if levelLabel:
		levelLabel.text = ""
	var levelCount = 1
	worldNameLabel.text = worldToLoad.worldName
	for levelLoad in worldToLoad.levelsResource:
		var newLevelButton:levelSelectButton = levelButtonRef.instantiate()
		newLevelButton.name = "levelSelectButton" + str(levelCount)
		
		if levelCount == 1:
			newLevelButton.startUnlocked = true
		else:
			newLevelButton.locked = true
			newLevelButton.levelLockParam = loadedLevelButtons[levelCount-2]
		newLevelButton.text = str(levelCount)
		newLevelButton.levelResourceRef = levelLoad
		newLevelButton.ownerMenuPanel = self
		loadedLevelButtons.append(newLevelButton)
		levelContainer.add_child(newLevelButton)
		levelCount += 1
	levelButtons = loadedLevelButtons
	levelButtonsLoaded.emit()
