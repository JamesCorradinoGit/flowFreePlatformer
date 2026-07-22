extends Sprite2D
class_name levelBGImage

@export_subgroup("Glimmer")
@export var glimmerObject: PackedScene
@export_range(0, 10, 0.1) var glimmerSpawnInterval: float = 1.0

func _ready() -> void:
	spawnRandomGlimmer()

func spawnRandomGlimmer():
	var localGlimmer:Sprite2D = glimmerObject.instantiate()
	var spawnY = randf_range(0, get_viewport().get_visible_rect().size.y)
	localGlimmer.global_position = Vector2(-100, spawnY)
	add_child(localGlimmer)
	await get_tree().create_timer(self.glimmerSpawnInterval).timeout
	spawnRandomGlimmer()
