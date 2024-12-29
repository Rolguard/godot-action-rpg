extends CharacterBody2D

const speed = 100
var current_direction = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)

	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)

	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)

	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)

	else:
		play_animation(0)
	
	var input_vector = Vector2.ZERO
	# get_action_strength returns a value from 0 - 1 representing the intensity of a given action.
	# E.g. for a controller how much force is used in moving the joystick away from the center
	# For a keyboard, it is mapped to 0 or 1. I.e. If the player is pressing right
	# Input.get_action_strength() returns 1 and if the input is not pressed, then it returns 0.
	# This means when you press right, input_vector.x = 0, left means input_vector.x = -1, similar for y

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# Normalise vector to ensure diagonal movement is not 1.4x faster due to pythagoras theorem
	# E.g. Pressing down and right will lead to movement of sqrt(2)
	# Normalising vector will ensure that any direction will have a magnitude (value/distance) of 1
	input_vector = input_vector.normalized()
	
	
	if input_vector:
		velocity = input_vector * speed
	else:
		# input_vector == Vector2(0, 0), because a zero vector is falsy
		velocity = input_vector
	
	move_and_slide()

func play_animation(movement):
# 1 = Moving animated sprite, 0 = Not moving/idle animated sprite
	var direction = current_direction
	var animation = $AnimatedSprite2D
	
	if direction == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if direction == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if direction == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			animation.play("back_idle")
	if direction == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			animation.play("front_idle")
