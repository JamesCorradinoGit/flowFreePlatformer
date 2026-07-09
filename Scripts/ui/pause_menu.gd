extends Control
class_name pauseMenu

@onready var pausePanel: Panel = $pausePanel
@onready var blurRect: ColorRect = $blurRect

signal hidePauseMenu

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	blurRect.material = blurRect.material.duplicate()
	blurRect.material.set_shader_parameter("amount", 0.0)
	tween.tween_property($blurRect, "material:shader_parameter/amount", 1.5, 0.5)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(pausePanel, "position:y", 74.0, 0.5)

func _on_continue_button_pressed() -> void:
	hidePauseMenu.emit()
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(pausePanel, "position:y", -600, 0.5)
	tween.tween_property($blurRect, "material:shader_parameter/amount", 0.0, 0.5)
	get_tree().paused = false
	await tween.finished
	queue_free()

func _on_restart_button_pressed() -> void:
	GlobalSceneLoader.loadScene(str(get_tree().current_scene.scene_file_path))
	get_tree().paused = false

func _on_menu_button_pressed() -> void:
	GlobalSceneLoader.loadScene("uid://cm0dmoglwp1ru")
	get_tree().paused = false
