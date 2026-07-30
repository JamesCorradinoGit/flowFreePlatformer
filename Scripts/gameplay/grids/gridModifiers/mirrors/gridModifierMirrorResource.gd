extends gridMiddleModifierObject
class_name gridMirror

enum ROTATIONS {TILT_LEFT, TILT_RIGHT}

@export var mirrorAngle:ROTATIONS = ROTATIONS.TILT_LEFT

var mirrorLoad:PackedScene = load("uid://bix4hsac3nc43")

func instanceGridObject() -> Node2D:
	var instMirror:scalableMirrorBaseGrid = mirrorLoad.instantiate().duplicate()
	match mirrorAngle:
		0: #45 deg
			instMirror.rotation_degrees = 45
		1: #135 deg
			instMirror.rotation_degrees = 135
	return instMirror
