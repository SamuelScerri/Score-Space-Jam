extends Node

@export var hats: Array[CompressedTexture2D]
@export var eyes: Array[CompressedTexture2D]
@export var shirts: Array[CompressedTexture2D]
@export var pants: Array[CompressedTexture2D]

@export var randomize: bool = true

var hat_id = 0
var eye_id = 0
var shirt_id = 0
var pants_id = 0

func _ready():
	if randomize:
		hat_id = randi_range(0, hats.size() - 1)
		eye_id = randi_range(0, eyes.size() - 1)
		shirt_id = randi_range(0, shirts.size() - 1)
		pants_id = randi_range(0, pants.size() - 1)
	
	else:
		hat_id = Global.current_game_area.citizen_enemy.hat_id
		eye_id = Global.current_game_area.citizen_enemy.eye_id
		shirt_id = Global.current_game_area.citizen_enemy.shirt_id
		pants_id = Global.current_game_area.citizen_enemy.pants_id
	
	$Hat.texture = hats[hat_id]
	$Eye.texture = eyes[eye_id]
	$Shirt.texture = shirts[shirt_id]
	$Pants.texture = pants[pants_id]
