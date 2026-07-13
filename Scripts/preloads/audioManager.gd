extends Node
class_name AudioManager

var activeSong: AudioStreamPlayer
var songList: Dictionary = {
	"menuWithoutIntro": "uid://dr5uum6ondds8",
	"tutorial": "uid://qkj24y50dgh"
}

#Created by Potheterr
func playGlobalSFX(sfxPath:String, decibels:float, pitchVariation:float = 0.0):
	var audioInst = AudioStreamPlayer.new()
	audioInst.process_mode = Node.PROCESS_MODE_ALWAYS
	audioInst.stream = load(sfxPath)
	audioInst.volume_db = decibels
	audioInst.pitch_scale += pitchVariation
	audioInst.autoplay = true
	audioInst.bus = "SFX"
	add_child(audioInst)
	await audioInst.finished
	audioInst.queue_free()

func playMusic(songPath:String, decibels:float, fadeIn:bool = true):
	var audioInst = AudioStreamPlayer.new()
	audioInst.process_mode = Node.PROCESS_MODE_ALWAYS
	audioInst.stream = load(songPath)
	audioInst.volume_db = decibels
	audioInst.autoplay = true
	audioInst.bus = "Music"
	activeSong = audioInst
	add_child(audioInst)
	if fadeIn:
		audioInst.volume_linear = 0.0
		var tween = create_tween()
		tween.tween_property(audioInst, "volume_linear", db_to_linear(decibels), 0.25)
func fadeOutMusicKeep(fadeTime:float = 0.25):
	var tween = create_tween()
	tween.tween_property(activeSong, "volume_linear", 0, fadeTime)
func fadeInMusicKeep(fadeTime:float = 0.25):
	var tween = create_tween()
	tween.tween_property(activeSong, "volume_linear", 1, fadeTime)
func fadeOutMusicRemove(fadeTime:float = 0.25):
	var tween = create_tween()
	tween.tween_property(activeSong, "volume_linear", 0, fadeTime)
	await tween.finished
	activeSong.queue_free()
