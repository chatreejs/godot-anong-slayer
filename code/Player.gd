extends KinematicBody2D

const SPEED = 500
const GRAVITY = 50
const JUMP_POWER = -800
const JUMP_TAP = -400
const FLOOR = Vector2(0, -1)
const DEADZONE = 0.3

var velocity = Vector2()
var look_direction = Vector2(1, 0)

var img_dash = preload("res://scene/dash.tscn")

var on_ground = true
var wall = false
var is_jump = false
var is_dash = false
var dashing = false

var state
enum {IDLE, RUN, JUMP, FALL, DASH, DEAD}

const TIMER_LIMIT = 0.5
var timer = 0.0

func _ready():
	change_state(IDLE)
	pass
	
func _physics_process(delta):
	timer += delta
	if timer > TIMER_LIMIT: # Prints every 2 seconds
		timer = 0.0
		print("fps: " + str(Engine.get_frames_per_second()))
	
	if Input.is_action_pressed("ui_right"):		
		if dashing == true:
			velocity.x = SPEED * 2.5
		else:
			velocity.x = SPEED
		
		$AnimatedSprite.flip_h = false
		
	elif Input.is_action_pressed("ui_left"):
		if dashing == true:
			velocity.x = -SPEED * 2.5
		else:
			velocity.x = -SPEED
		
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("jump"):
		jump()
		if !is_jump:
			Input.start_joy_vibration(0, 1, 0, 0.1)
	if Input.is_action_just_released("jump"):
		jump_cut()
		is_jump = true

	if Input.is_action_just_pressed("dash"):
		if !is_on_wall() and abs(velocity.x) > 0 and !is_dash:
			dashing = true
			is_dash = true
			Input.start_joy_vibration(0, 1, 1, 0.2)
			change_state(DASH)
			
	if wall == true and Input.is_action_pressed("grab"):
		velocity.y = -20
		$AnimatedSprite.play("grab")
		if Input.is_action_just_pressed("jump"):
			velocity = Vector2(-velocity.x * 2, -750)
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
		
	if is_on_wall():
		wall = true
	else:
		wall = false

	velocity = move_and_slide(velocity, FLOOR)
	state_loop()
	
func jump():
	if on_ground == true:
		velocity.y = JUMP_POWER
		on_ground = false
	
func jump_cut():
	if velocity.y < -100:
		velocity.y = -100

func state_loop():
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	if state == JUMP and velocity.y > 0 and !is_on_floor():
		change_state(FALL)
	if state in [JUMP, FALL] and is_on_floor():
		change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimatedSprite.play("idle")
		RUN:
			$AnimatedSprite.play("run")
		JUMP:
			$AnimatedSprite.play("jump")
		FALL:
			$AnimatedSprite.play("fall")
		DASH:
			for x in range(0, 3):
				var i = img_dash.instance()
				i.init(position, $AnimatedSprite)
				get_parent().add_child(i)
				yield(get_tree().create_timer(0.05), 'timeout')
			dashing = false
			change_state(IDLE)

func _on_Timer_timeout():
	SPEED = 500