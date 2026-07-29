extends StaticBody2D
class_name laserPoinerReciever

@export var colorToRecieve = Color.WHITE
@export var objToConnectTo:Array[interactableMechanism]
@export var mechanismID:int = 0

@onready var recieverEnergyColor: Sprite2D = $recieverEnergyColor
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var isConnected:bool = false

signal laserConnect
signal laserDisconnect

func _ready() -> void:
	laserConnect.connect(onSelfLaserConnect)
	laserDisconnect.connect(onSelfLaserDisconnect)
	recieverEnergyColor.self_modulate = colorToRecieve

func onSelfLaserConnect():
	isConnected = true
	if objToConnectTo:
		for obj in objToConnectTo:
			obj.mechanismConnect.emit(mechanismID)
func onSelfLaserDisconnect():
	isConnected = false
	if objToConnectTo:
		for obj in objToConnectTo:
			obj.mechanismDisconnect.emit(mechanismID)
