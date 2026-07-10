extends Panel
class_name settingsMenu

var controlParent: mainMenuCanvas

func _ready() -> void: #precondition that settings menu is instanciated to main menu
	if get_parent() is mainMenuCanvas:
		controlParent = get_parent()

func _on_fullscreen_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_button_pressed() -> void:
	controlParent.hideExtraMenu.emit()
	controlParent.showButtons.emit()
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx

func _on_back_button_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
