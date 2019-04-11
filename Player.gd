extends KinematicBody2D

const SPEED = 500
const GRAVITY = 40
const JUMP_POWER = -750
const JUMP_TAP = -400
const FLOOR = Vector2(0, -1)
const DEADZONE = 0.3

var velocity = Vector2()

var on_ground = true
var wall = false
var is_dash = false
var is_jump = false

func _ready():
	pass
	
func _physics_process(delta):
	var is_moving = Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0
		if on_ground == true:
			$AnimatedSprite.play("idle")
			
	if Input.is_action_just_pressed("jump"):
		jump()
		if !is_jump:
			Input.start_joy_vibration(0, 1, 0, 0.1)
	if Input.is_action_just_released("jump"):
		jump_cut()
		is_jump = true
		
	if Input.is_action_just_pressed("dash"):
		if(!is_dash && !wall):
			if on_ground:
				dash()
			else:
				velocity.y = -200
				dash()
			if abs(velocity.x) > 0:
				Input.start_joy_vibration(0, 1, 1, 0.2)
			is_dash = true
			
	if wall == true and Input.is_action_pressed("grab"):
		velocity.y = -20
		$AnimatedSprite.play("grab")
		if Input.is_action_just_pressed("jump"):
			velocity = Vector2(-velocity.x * 2, -700)
			velocity = move_and_slide(velocity, FLOOR)
			$AnimatedSprite.play("air_run")
			Input.start_joy_vibration(0, 1, 1, 0.1)
		
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
		is_jump = false
		is_dash = false
	else:
		on_ground = false
		if velocity.y < 0:
			if abs(velocity.x) > 0:
				$AnimatedSprite.play("air_run")
			else:
				$AnimatedSprite.play("jump")
		else:
			if wall == false:
				$AnimatedSprite.play("fall")
		
	if is_on_wall():
		wall = true
#		print("on_wall")
	else:
		wall = false
		
	velocity = move_and_slide(velocity, FLOOR)
	
func jump():
	if on_ground == true:
		velocity.y = JUMP_POWER
		on_ground = false
	
func jump_cut():
	if velocity.y < -100:
		velocity.y = -100
		
func dash():
	SPEED = 1500
	$dash_timer.start()

func _on_Timer_timeout():
	SPEED = 500

func _on_ghost_timer_timeout():
	if abs(velocity.x) > 1000  && !wall:
		var this_ghost = preload("res://ghost.tscn").instance()
		get_parent().add_child(this_ghost)
		this_ghost.position = position
		this_ghost.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)