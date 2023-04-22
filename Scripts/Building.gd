extends StaticBody2D

var health = 100

func _ready():
	update_information()

func damage(amount: int = 10):
	health -= amount
	
	update_information()
	$Animation.play("Damage")

func update_information():
	$Sprite/Label.text = str(health)
