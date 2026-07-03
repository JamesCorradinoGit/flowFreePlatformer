extends Panel
class_name extrasMenu

var controlParent: mainMenuCanvas

func _ready() -> void: #precondition that settings menu is instanciated to main menu
	if get_parent() is mainMenuCanvas:
		controlParent = get_parent()

func _on_back_button_pressed() -> void:
	controlParent.hideExtraMenu.emit()
	controlParent.showButtons.emit()
