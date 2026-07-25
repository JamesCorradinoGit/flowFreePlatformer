@tool
extends gridButtonInteractable

@export var xSize: int = 2
@export var ySize:int = 6
@export var doorColor:Color = Color(1.0, 1.0, 1.0, 1.0)
@export var doorDisabled:bool = false
@export var allowPlayerButtonDisabling:bool = true
@export_subgroup("Door Movements")
@export_enum("Down", "Up", "Left", "Right") var direction:int = 0
@export var magnitude: int = 100
@export var tweenTime: float = 0.5

@onready var collisionDoor: CollisionShape2D = $collisionDoor
@onready var textures: NinePatchRect = $textures

var directionSprite:Sprite2D

var arrowSprite = load("uid://co8em0ucdppad")
var xPixelSize:int
var yPixelSize:int
var originPos:Vector2
var newPos:Vector2
var isTweening:bool = false
var connectedGridButtonIsActive:bool = false

var activeMovingTween: Tween

var doorDisabledSprite = load("uid://bv0th8ahcj1n8")
var tweenDisableTime = 0.25

signal disableDoor
signal enableDoor

func _ready() -> void:
	if Engine.is_editor_hint():
		collisionDoor.visible = false
		textures.visible = false
		return
	xPixelSize = Globals.globalSnap * self.xSize
	yPixelSize = Globals.globalSnap * self.ySize
	originPos = position
	disableDoor.connect(disableDoorFunc)
	enableDoor.connect(enableDoorFunc)
	
	textures.visible = true
	textures.size = Vector2(xPixelSize, yPixelSize)
	textures.material = textures.material.duplicate()
	textures.material.set_shader_parameter("newColor", doorColor)
	textures.self_modulate = doorColor
	textures.self_modulate.a /= 2
	
	collisionDoor.visible = true
	@warning_ignore("integer_division")
	collisionDoor.position = Vector2(xPixelSize/2, yPixelSize/2)
	var fillShape = RectangleShape2D.new()
	fillShape.size = Vector2(xPixelSize, yPixelSize)
	collisionDoor.shape = fillShape
	
	var directionSpriteInst = Sprite2D.new()
	directionSpriteInst.texture = arrowSprite
	directionSpriteInst.scale = Vector2(1.5, 1.5)
	@warning_ignore("integer_division")
	directionSpriteInst.position = Vector2(xPixelSize/2, yPixelSize/2)
	match direction:
		0: #down
			newPos = Vector2(position.x, position.y + self.magnitude)
		1: #up
			newPos = Vector2(position.x, position.y - self.magnitude)
			directionSpriteInst.rotation_degrees = 180
		2: #left
			newPos = Vector2(position.x - self.magnitude, position.y)
			directionSpriteInst.rotation_degrees = 90
		3: #right
			newPos = Vector2(position.x + self.magnitude, position.y)
			directionSpriteInst.rotation_degrees = 270
	directionSprite = directionSpriteInst
	add_child(directionSpriteInst)
	
	if self.doorDisabled:
		disableDoor.emit()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(
			Rect2(Vector2.ZERO, Vector2i(Globals.globalSnap * self.xSize, Globals.globalSnap * self.ySize)),
			doorColor,
			false)

func disableDoorFunc():
	var tempColor = doorColor
	var innerTempColor = doorColor
	var tween = create_tween()
	tempColor.v /= 2
	innerTempColor.v /= 4
	doorDisabled = true
	if directionSprite:
		directionSprite.texture = doorDisabledSprite
		directionSprite.self_modulate.a = 0.0
	
	tween.set_parallel()
	tween.tween_method(shiftNewColTexture, doorColor, tempColor, tweenDisableTime)
	tween.tween_property(textures, "self_modulate", innerTempColor, tweenDisableTime)
	tween.tween_property(directionSprite, "self_modulate:a", 1.0, tweenDisableTime)
func enableDoorFunc():
	var tween = create_tween()
	var innerTempColor = doorColor
	innerTempColor.a /= 2
	doorDisabled = false
	if directionSprite:
		directionSprite.texture = arrowSprite
		directionSprite.self_modulate.a = 0.0
	
	tween.set_parallel()
	tween.tween_method(shiftNewColTexture, textures.material.get_shader_parameter("newColor"), doorColor, tweenDisableTime)
	tween.tween_property(textures, "self_modulate", innerTempColor, tweenDisableTime)
	tween.tween_property(directionSprite, "self_modulate:a", 1.0, tweenDisableTime)
	
	if connectedGridButtonIsActive:
		onGridButtonPressed()
	else:
		onGridButtonUnpress()
func moveDoorToNewLoc():
	isTweening = true
	if activeMovingTween:
		activeMovingTween.kill()
		
	var speedTDefault = originPos.distance_to(newPos) / tweenTime
	var timeToTweenAccurate = position.distance_to(newPos) / (speedTDefault)
		
	activeMovingTween = create_tween()
	activeMovingTween.finished.connect(func(): isTweening = false)
		
	activeMovingTween.tween_property(self, "position", newPos, timeToTweenAccurate)
func moveDoorToOldLoc():
	isTweening = true
	if activeMovingTween:
		activeMovingTween.kill()
	
	var speedTDefault = newPos.distance_to(originPos) / tweenTime
	var timeToTweenAccurate = position.distance_to(originPos) / (speedTDefault)
	
	activeMovingTween = create_tween()
	activeMovingTween.finished.connect(func(): isTweening = false)
	
	activeMovingTween.tween_property(self, "position", originPos, timeToTweenAccurate)

func shiftNewColTexture(col:Color):
	textures.material.set_shader_parameter("newColor", col)

func onGridButtonPressed():
	connectedGridButtonIsActive = true
	if self.doorDisabled == false:
		moveDoorToNewLoc()
func onGridButtonUnpress():
	connectedGridButtonIsActive = false
	if self.doorDisabled == false:
		moveDoorToOldLoc()

func onPlayerButtonPressed(type:int):
	match type:
		0:
			if self.allowPlayerButtonDisabling:
				doorDisabled = !doorDisabled
				if doorDisabled:
					disableDoor.emit()
				else:
					enableDoor.emit()
		1:
			moveDoorToNewLoc()
func onPlayerButtonReleased(type:int):
	match type:
		0: #disable
			if self.allowPlayerButtonDisabling:
				doorDisabled = !doorDisabled
				if doorDisabled:
					disableDoor.emit()
				else:
					enableDoor.emit()
		1: #move
			moveDoorToOldLoc()
