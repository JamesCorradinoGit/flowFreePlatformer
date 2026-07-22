extends Button

@export var levelSelectMenuNode:levelSelectMenu
@export var tweenOffset: Vector2
@export var tweenTime: float = 0.25
@export_category("World Menu")
@export var menuWorldResource: levelWorld
@export var customWorldMenuScene:PackedScene ##only use if you want a custom world menu

var originPos:Vector2

#CONNECT SIGNALS

func _ready() -> void:
	await get_tree().process_frame
	originPos = self.global_position

func _on_pressed() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cuye2nxn50u2y", 3.0) #press sfx
	if levelSelectMenuNode.bannerInTransition == false:
		if menuWorldResource != null:
			if customWorldMenuScene != null:
				levelSelectMenuNode.switchCurrentLoadedWorldCustom.emit(customWorldMenuScene, menuWorldResource)
			else:
				levelSelectMenuNode.switchCurrentLoadedWorldAuto.emit(menuWorldResource)
		else:
			push_error(self.name + " needs a world resource!")

func _on_mouse_entered() -> void:
	GlobalAudioManager.playGlobalSFX("uid://cdh404qobufe4", 3.0) #hover sfx
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + tweenOffset, tweenTime)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", originPos, tweenTime)
