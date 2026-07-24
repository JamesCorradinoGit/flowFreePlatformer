extends CharacterBody2D

@export var coyoteTimer:Timer
@export var tweenTime:float = 0.5
@onready var playerSprite: AnimatedSprite2D = $playerSprite

const SPEED = 300.0
const JUMP_VELOCITY = -425.0
const ACCEL = 2200

var heldJump:bool = false
var canJump:bool = true
var isRespawning:bool = false

var wasLastFrameInAir:bool = false

signal triggerRespawn

func _ready() -> void:
	triggerRespawn.connect(respawnFunc)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor() and wasLastFrameInAir:
		onLand()
	if Globals.isAlreadyDragging == true:
		velocity.x = 0
	if Globals.isAlreadyDragging == false:
		#region jump
		if is_on_floor() and canJump == false:
			wasLastFrameInAir = false
			canJump = true
		if canJump:
			if Input.is_action_just_pressed("jump"):
				jump("normalJump")
		elif velocity.y < 0.0 and Input.is_action_just_released("jump"):
				jump("jumpCancel")
		if (is_on_floor() == false) and canJump and coyoteTimer.is_stopped():
			coyoteTimer.start()
		#endregion
		#region baseMovement
		var direction := Input.get_axis("moveLeft", "moveRight")
		
		if direction > 0:
			playerSprite.flip_h = false
		elif direction < 0:
			playerSprite.flip_h = true
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, direction*SPEED, ACCEL*delta)
		#endregion
	#region animation
	animateSprite()
	#endregion
	checkCollisionValid()
	move_and_slide()
	
	if is_on_floor() == false:
		wasLastFrameInAir = true

func jump(jumpType:String):
	match jumpType:
		"normalJump":
			GlobalAudioManager.playGlobalSFX("uid://7wrv6s08ncoi", -4.0, randf_range(-.25,0))
			velocity.y = JUMP_VELOCITY
			canJump = false
		"jumpCancel":
			velocity.y *= 0.2
func onLand():
	GlobalAudioManager.playGlobalSFX("uid://bxlxo4i5b2qj7", 0, 0.2)
	wasLastFrameInAir = false

func animateSprite():
	if is_on_floor() == false:
		if velocity.y > 0.0:
			playerSprite.play("fall")
		elif velocity.y < 0.0:
			playerSprite.animation = "jump"
	elif velocity.x != 0:
		playerSprite.play("run")
	else:
		playerSprite.play("idle")
func checkCollisionValid():
	var isInWall:KinematicCollision2D = move_and_collide(Vector2.ZERO, true)
	if isInWall and not isRespawning:
		if isInWall.get_collider_velocity().y < 0:
			return
		playerSprite.play("squish")
		triggerRespawn.emit()

func respawnFunc(): 
	if get_parent() is level:
		set_physics_process(false)
		
		var tween = create_tween()
		tween.tween_property($playerSprite, "self_modulate:a", 0.0, tweenTime)
		tween.play()
		await get_tree().create_timer(tweenTime).timeout
		
		tween.stop()
		global_position = get_parent().playerSpawn.global_position
		tween.tween_property($playerSprite, "self_modulate:a", 1.0, tweenTime)
		tween.play()
		await(get_tree().create_timer(tweenTime+0.75).timeout)
		set_physics_process(true)
		isRespawning = false

func _on_coyote_timer_timeout() -> void:
	canJump = false
