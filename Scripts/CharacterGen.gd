extends Node

@export var hats: Array[CompressedTexture2D]
@export var eyes: Array[CompressedTexture2D]
@export var shirts: Array[CompressedTexture2D]
@export var pants: Array[CompressedTexture2D]

func _ready():
	$Hat.texture = hats[randi_range(0, hats.size() - 1)]
	$Eye.texture = eyes[randi_range(0, eyes.size() - 1)]
	$Shirt.texture = shirts[randi_range(0, shirts.size() - 1)]
	$Pants.texture = pants[randi_range(0, pants.size() - 1)]
