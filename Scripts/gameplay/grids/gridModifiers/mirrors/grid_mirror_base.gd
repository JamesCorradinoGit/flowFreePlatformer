extends StaticBody2D
class_name scalableMirrorBaseGrid

@export var degToRotate:float = 0.0

@onready var mirrorCol: CollisionShape2D = $mirrorCol
@onready var textures: NinePatchRect = $textures

var xSize:float = 0.5
var ySize:float = 1
var xPixelSize:float
var yPixelSize:float

"""
func _ready() -> void:
	if Engine.is_editor_hint():
		mirrorCol.visible = false
		textures.visible = false
		return
	xPixelSize = Globals.globalSnap * self.xSize
	yPixelSize = Globals.globalSnap * self.ySize
	
	textures.visible = true
	textures.size = Vector2(xPixelSize, yPixelSize)
	textures.position = Vector2(-xPixelSize/2.0, -yPixelSize/2.0)
	
	mirrorCol.visible = true
	@warning_ignore("integer_division")
	#mirrorCol.position = Vector2(xPixelSize/2, yPixelSize/2)
	var fillShape = RectangleShape2D.new()
	fillShape.size = Vector2(xPixelSize, yPixelSize)
	mirrorCol.shape = fillShape
"""
