@tool
extends StaticBody2D
class_name scalableMirrorBase

@export var xSize:int = 2
@export var ySize:int = 2

@onready var mirrorCol: CollisionShape2D = $mirrorCol
@onready var textures: NinePatchRect = $textures

var xPixelSize:int
var yPixelSize:int

func _ready() -> void:
	if Engine.is_editor_hint():
		mirrorCol.visible = false
		textures.visible = false
		return
	xPixelSize = Globals.globalSnap * self.xSize
	yPixelSize = Globals.globalSnap * self.ySize
	
	textures.visible = true
	textures.size = Vector2(xPixelSize, yPixelSize)
	
	mirrorCol.visible = true
	@warning_ignore("integer_division")
	mirrorCol.position = Vector2(xPixelSize/2, yPixelSize/2)
	var fillShape = RectangleShape2D.new()
	fillShape.size = Vector2(xPixelSize, yPixelSize)
	mirrorCol.shape = fillShape

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(
			Rect2(Vector2.ZERO, Vector2i(Globals.globalSnap * self.xSize, Globals.globalSnap * self.ySize)),
			Color.WHITE,
			false)
