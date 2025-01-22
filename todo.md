# Completed:
- Add y-sorting to enemy slime (incorrectly displays in front of obstacles like trees)
- Add battle system



# TODO:
- Did I get it right, you're running a timer on the player for enemy attack cooldown? 
	I think you should have separate timers for player and enemy scenes for respective cooldowns 
	and trigger damage dealing from attacker to target. It would just make so much more sense
	
	# Hitboxes deal damage, hurtboxes receive damage
	
# Currently player attack glitches out/stutters near end of attack animation before going to idle
--> Fixed by either changing the attack_cooldown to be 0.5 seconds or deselecting loop animation 
	For all attack animations (e.g. side_attack) in the AnimatedSprite2D for the player
	
		
	# Looks like the movement key overrides the attack animation
	# Enemy also takes damage very quickly, this was fixed in the tutorial by setting receive_damage_cooldown
	
- Add static typing to variables
- Need to use node references

	
- Cliff y-sort still needs to be tested (might need to change z-index)
- Consider line of sight (LoS) and system to create smarter enemies https://www.youtube.com/watch?v=wC9iu7cuQjI
