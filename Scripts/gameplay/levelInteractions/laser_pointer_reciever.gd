extends StaticBody2D
class_name laserPoinerReciever

@export var colorToRecieve = Color.WHITE
@export var objToConnectTo:interactableMechanism
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
	objToConnectTo.mechanismConnect.emit(mechanismID)
func onSelfLaserDisconnect():
	objToConnectTo.mechanismDisconnect.emit(mechanismID)
