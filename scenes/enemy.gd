extends CharacterBody2D

var speed = 50
var chase_player = false
var player = null

func _physics_process(delta):
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

func _on_detection_area_body_entered(body):
	player = body
	chase_player = true


func _on_detection_area_body_exited(body):
	player = null
	chase_player = false
