extends CharacterBody2D

@export var coyoteTimer:Timer
@export var tweenTime:float = 0.5

const SPEED = 325.0
const JUMP_VELOCITY = -450.0

var heldJump:bool = false
var canJump:bool = true
var isRespawning:bool = false

signal triggerRespawn

func _ready() -> void:
	triggerRespawn.connect(respawnFunc)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Globals.isAlreadyDragging == false:
		#region jump
		if is_on_floor() and canJump == false:
			canJump = true
		if canJump:
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
				canJump = false
		elif velocity.y < 0.0:
			if Input.is_action_just_released("jump"):
				velocity.y *= 0.2
		if (is_on_floor() == false) and canJump and coyoteTimer.is_stopped():
			coyoteTimer.start()
		#endregion
		
		var direction := Input.get_axis("moveLeft", "moveRight")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

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
