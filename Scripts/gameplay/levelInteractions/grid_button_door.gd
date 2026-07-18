@tool
extends gridButtonInteractable

@export var xSize: int = 2
@export var ySize:int = 6
@export var doorColor:Color = Color(1.0, 1.0, 1.0, 1.0)
@export_subgroup("Door Movements")
@export_enum("Down", "Up", "Left", "Right") var direction:int = 0
@export var magnitude: int = 100
@export var tweenTime: float = 0.5

@onready var collisionDoor: CollisionShape2D = $collisionDoor
@onready var textures: NinePatchRect = $textures

var arrowSprite = load("uid://co8em0ucdppad")
var xPixelSize:int
var yPixelSize:int
var originPos:Vector2
var newPos:Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		collisionDoor.visible = false
		textures.visible = false
		return
	xPixelSize = Globals.globalSnap * self.xSize
	yPixelSize = Globals.globalSnap * self.ySize
	
	originPos = position
	
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
	
	var directionSprite = Sprite2D.new()
	directionSprite.texture = arrowSprite
	directionSprite.scale = Vector2(1.5, 1.5)
	@warning_ignore("integer_division")
	directionSprite.position = Vector2(xPixelSize/2, yPixelSize/2)
	match direction:
		0: #down
			newPos = Vector2(position.x, position.y + self.magnitude)
		1: #up
			newPos = Vector2(position.x, position.y - self.magnitude)
			directionSprite.rotation_degrees = 180
		2: #left
			newPos = Vector2(position.x - self.magnitude, position.y)
			directionSprite.rotation_degrees = 90
		3: #right
			newPos = Vector2(position.x + self.magnitude, position.y)
			directionSprite.rotation_degrees = 270
	add_child(directionSprite)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(
			Rect2(Vector2.ZERO, Vector2i(Globals.globalSnap * self.xSize, Globals.globalSnap * self.ySize)),
			doorColor,
			false)

func onGridButtonPressed():
	var tween = create_tween()
	tween.tween_property(self, "position", newPos, tweenTime)
func onGridButtonUnpress():
	var tween = create_tween()
	tween.tween_property(self, "position", originPos, tweenTime)
