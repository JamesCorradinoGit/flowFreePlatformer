extends Panel
class_name extrasMenu

var controlParent: mainMenuCanvas

func _ready() -> void: #precondition that settings menu is instanciated to main menu
	if get_parent() is mainMenuCanvas:
		controlParent = get_parent()

func _on_back_button_pressed() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx
	controlParent.hideExtraMenu.emit()
	controlParent.showButtons.emit()

func _on_back_button_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
