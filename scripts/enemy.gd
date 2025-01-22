extends CharacterBody2D

@export var speed: int = 50
var chase_player: bool = false
@onready var player: CharacterBody2D = $"../player"

@export var health: int = 100
var player_in_range: bool = false
var can_receive_damage: bool = true
@export var attack: int = 2

func _physics_process(delta: float) -> void:
	simulate_combat()
	
	if chase_player:
		position += (player.position - position) / speed
		
		$AnimatedSprite2D.play("walk")
		# Adjust direction of animation based on the enemy facing direction towards player
		
		if (player.position.x - position.x) < 0:
			# Moving left, face animation left
			$AnimatedSprite2D.flip_h = true
		else:
			# Moving right, face animation right
			$AnimatedSprite2D.flip_h = false
		
		move_and_collide(Vector2(0, 0))
		
	else:
		$AnimatedSprite2D.play("idle")

func simulate_combat() -> void:
	if player_in_range and player.can_receive_damage:
		player.receive_damage(attack * 10)
	
	if player_in_range and player.is_attacking and can_receive_damage:
		receive_damage(player.attack * 10)
# TODO: Replace check_damage_dealt with deal_damage
# The player should have an receive_damage_cooldown / vulnerable_cooldown AND 
# attack_cooldown (how often they can spam their attack button i.e. 'e')
# The enemy should have an attack_cooldown (how often they can jump and touch player)
# Also the if statement check should be put in the physics_process and
# The function should have the code for dealing the damage
#func deal_damage(damage: int) -> void:
	#player.health -= damage
	#player.can_receive_damage = false
	#player.receive_damage_cooldown.start()

func receive_damage(damage: int) -> void:
	if can_receive_damage:
		health -= damage
		$receive_damage_cooldown.start()
		can_receive_damage = false
		print("Slime has taken %d damage! Slime health: %d" % [damage, health])
		if health <= 0:
			self.queue_free()
#
#func check_damage_dealt() -> void:
## Opposite should be deal_damage()
	#if player_in_range and Global.player_attacking and can_receive_damage:
		#health = health - 20
		#$receive_damage_cooldown.start()
		#can_receive_damage = false
		#print("Slime has taken damage! Slime health: %d" % [health])
		#if health <= 0:
			#self.queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		chase_player = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		chase_player = false


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
	
func _on_receive_damage_cooldown_timeout() -> void:
	can_receive_damage = true
