extends StaticBody2D

var health = 100

func _ready():
	update_information()

func damage(amount: int = 10):
	health -= amount
	
	update_information()
	
	Global.current_game_area.do_shake()
	$Animation.play("Damage")
	
	if health <= 0:
		Global.current_game_area.end_game()

func update_information():
	$Sprite/Label.text = str(health)
