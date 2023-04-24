extends CanvasGroup

@export var hats: Array[CompressedTexture2D]
@export var eyes: Array[CompressedTexture2D]
@export var shirts: Array[CompressedTexture2D]
@export var pants: Array[CompressedTexture2D]

@export var unique_character: bool = false

var hat_id = 0
var eye_id = 0
var shirt_id = 0
var pants_id = 0

func generate_clothes():
	hat_id = randi_range(0, hats.size() - 1)
	eye_id = randi_range(0, eyes.size() - 1)
	shirt_id = randi_range(0, shirts.size() - 1)
	pants_id = randi_range(0, pants.size() - 1)

	change_clothes()

func has_enemy_clothes():
	var enemy_clothes = Global.get_current_game_area().enemy_clothes
	
	return hat_id == enemy_clothes.hat_id and eye_id == enemy_clothes.eye_id and shirt_id == enemy_clothes.shirt_id and pants_id == enemy_clothes.pants_id

func change_clothes():
	$Hat.texture = hats[hat_id]
	$Eye.texture = eyes[eye_id]
	$Shirt.texture = shirts[shirt_id]
	$Pants.texture = pants[pants_id]
	
	#Hard Coded Modulations
	match shirt_id:
		0:
			$Character.modulate = Color8(255, 205, 128)
		1:
			$Character.modulate = Color8(83, 83, 83)
		2:
			$Character.modulate = Color8(170, 170, 170)
		3:
			$Character.modulate = Color8(119, 119, 119)
		4:
			$Character.modulate = Color8(119, 119, 119)

func _ready():
	if not unique_character:
		hat_id = Global.get_current_game_area().enemy_clothes.hat_id
		eye_id = Global.get_current_game_area().enemy_clothes.eye_id
		shirt_id = Global.get_current_game_area().enemy_clothes.shirt_id
		pants_id = Global.get_current_game_area().enemy_clothes.pants_id
	
	change_clothes()
