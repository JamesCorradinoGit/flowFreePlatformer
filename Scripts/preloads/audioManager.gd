extends Node
class_name AudioManager

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

func playMusic():
	pass
