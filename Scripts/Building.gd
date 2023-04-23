extends Node

var health = 100

func damage(amount: int):
	$Feedback.play("Damage")
	$Audio.play()
	Global.get_current_game_area().shake_camera()
	$ColorRect.scale.x = lerpf(0, 1, health / 100.0)
	$ColorRect.color.g = lerpf(0, 1, health / 100.0)
	$ColorRect.color.b = lerpf(0, 1, health / 100.0)
	
	health -= amount
	if health < 0:
		Global.get_current_game_area().end_game()

