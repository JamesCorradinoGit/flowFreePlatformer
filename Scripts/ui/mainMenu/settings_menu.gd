extends Panel
class_name settingsMenu

@onready var masterVolumeSlider: HSlider = $audioContainer/audioVbox/masterVolumeSlider
@onready var musicVolumeSlider: HSlider = $audioContainer/audioVbox/musicVolumeSlider
@onready var sfxVolumeSlider: HSlider = $audioContainer/audioVbox/sfxVolumeSlider

var controlParent: mainMenuCanvas

func _ready() -> void: #precondition that settings menu is instanciated to main menu
	if get_parent() is mainMenuCanvas:
		controlParent = get_parent()
	masterVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Master")))
	musicVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Music")))
	sfxVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("SFX")))

func _on_fullscreen_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#region Audio
func changeAudioBusVolume(busName:String, vol: float):
	var busIndex:int = AudioServer.get_bus_index(busName)
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(vol))
func _on_master_volume_slider_value_changed(value: float) -> void:
	changeAudioBusVolume("Master", value)
func _on_music_volume_slider_value_changed(value: float) -> void:
	changeAudioBusVolume("Music", value)
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	changeAudioBusVolume("SFX", value)
#endregion

func _on_back_button_pressed() -> void:
	controlParent.hideExtraMenu.emit()
	controlParent.showButtons.emit()
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx
func _on_back_button_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
