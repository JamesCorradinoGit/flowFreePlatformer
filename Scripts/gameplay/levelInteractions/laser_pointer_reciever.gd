extends StaticBody2D
class_name laserPoinerReciever

@export var colorToRecieve = Color.WHITE
@export var objToConnectTo:Array[interactableMechanism]
@export var mechanismID:int = 0

@onready var recieverEnergyColor: Sprite2D = $recieverEnergyColor
@onready var laserPointerConnectedParticle: GPUParticles2D = $laserPointerConnectedParticle

var isConnected:bool = false

signal laserConnect
signal laserDisconnect

func _ready() -> void:
	laserConnect.connect(onSelfLaserConnect)
	laserDisconnect.connect(onSelfLaserDisconnect)
	recieverEnergyColor.self_modulate = colorToRecieve
	laserPointerConnectedParticle.self_modulate = colorToRecieve

func onSelfLaserConnect():
	laserPointerConnectedParticle.visible = true
	isConnected = true
	if objToConnectTo:
		for obj in objToConnectTo:
			obj.mechanismConnect.emit(mechanismID)
func onSelfLaserDisconnect():
	isConnected = false
	laserPointerConnectedParticle.visible = false
	if objToConnectTo:
		for obj in objToConnectTo:
			obj.mechanismDisconnect.emit(mechanismID)
