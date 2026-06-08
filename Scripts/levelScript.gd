extends Node2D

@export var playerSpawn:Marker2D
@export var goalPortal:levelPortal

var player:PackedScene = load("uid://cvslsain1kjbi")

@warning_ignore("unused_signal")
signal completeLevel

func _ready() -> void:
	goalPortal.goalReached.connect(onLevelComplete)
	var tempPlayer:CharacterBody2D = player.instantiate().duplicate()
	tempPlayer.global_position = playerSpawn.global_position
	add_child(tempPlayer)

func onLevelComplete():
	print("done")
