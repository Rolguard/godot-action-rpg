extends CharacterBody2D

const speed: int = 95
var current_direction: String = "right"

var enemy_in_range: bool = false
var enemies_in_range: Array[Node2D] = []
var can_receive_damage: bool = true
var health: int = 100	
var attack: int = 2

var alive: bool = true
var is_attacking: bool = false

@onready var receive_damage_cooldown: Timer = $receive_damage_cooldown

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	simulate_combat()
	#check_damage_received()
	
	
	if health <= 0:
		# When the player dies, can play game over screen
		alive = false
		health = 0
		print("Player has died.")
		

func player_movement(delta: float) -> void:
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

func play_animation(movement: int) -> void:
# 1 = Moving animated sprite, 0 = Not moving/idle animated sprite
	var direction = current_direction
	var animation = $AnimatedSprite2D
	
	if direction == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if not is_attacking:
				animation.play("side_idle")
	if direction == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if not is_attacking:
				animation.play("side_idle")
	if direction == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if not is_attacking:
				animation.play("back_idle")
	if direction == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if not is_attacking:
				animation.play("front_idle")

func simulate_combat() -> void:
	# Might need to add attack_cooldown / is_attacking variable to control
	# Number of times attack button 'e' can be pressed to display attack animation
	# And deal damage to enemiese
	if Input.is_action_just_pressed("attack") and not is_attacking:
		perform_attack()
		for enemy in enemies_in_range:
			enemy.receive_damage(attack * 10)

func receive_damage(damage: int) -> void:
	health -= damage
	can_receive_damage = false
	receive_damage_cooldown.start()
	print("Player has taken %d damage! Player health: %d" % [damage, health])
#func check_damage_received() -> void:
	#if enemy_in_range and can_receive_damage:
		#health = health - 20
		#can_receive_damage = false
		#$receive_damage_cooldown.start()
		#print("Player took damage, current player health: %d" % [health])

func perform_attack() -> void:
	var direction = current_direction
	is_attacking = true
	$attack_cooldown.start()
	if direction == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_attack")
	if direction == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_attack")
	if direction == "down":
		$AnimatedSprite2D.play("front_attack")
	if direction == "up":
		$AnimatedSprite2D.play("back_attack")
		

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func _on_attack_cooldown_timeout() -> void:
	$attack_cooldown.stop()
	is_attacking = false

func _on_receive_damage_cooldown_timeout() -> void:
	can_receive_damage = true
