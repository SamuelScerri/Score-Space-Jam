extends ColorRect

var velocity = 32
var height = 0

func _process(delta):
	velocity -= delta * 8
	
	height += velocity * delta
	scale = Vector2(height, height)
