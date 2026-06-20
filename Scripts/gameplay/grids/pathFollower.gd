extends PathFollow2D

@export var speed:float = 1.0

func _process(_delta: float) -> void:
	progress_ratio += 0.001*speed
