extends Node

var score: int = 0

#@onready var user_interface = $Interface

@export var max_citizens_in_area = 32
@export var enemy_chance_percentage = .2

@export var citizen_node: PackedScene
@export var enemy_node: PackedScene

func _ready():
	Global.current_game_area = self
	#get_tree().paused = true
	
	#We Will Now Create A Bunch Of Citizens
	for i in range(max_citizens_in_area):
		spawn_citizen()

func spawn_citizen():
	var citizen = citizen_node.instantiate()
	citizen.global_position = Vector2(randi_range(0, 1) * (1024 / float(randi_range(1, 2))), randi_range(0, 1) * (768 / float(randi_range(1, 2))))
	
	add_child(citizen)

func respawn_citizen():
	var furthest_citizen = get_furthest_citizen(get_tree().get_nodes_in_group("Citizen"), get_tree().get_first_node_in_group("Building"))
	var citizen = citizen_node.instantiate()
	citizen.global_position = furthest_citizen.global_position
	add_child(citizen)

func start_game():
	get_tree().paused = false
	print("Starting Game")

func _process(delta):
	if Input.is_action_just_pressed("Fire"):
		$Fire.play()

func get_furthest_citizen(citizens: Array, building):
	var furthest_citizen: CharacterBody2D = null
	var furthest_distance = 0
	
	for citizen in citizens:
		if furthest_distance == 0 or citizen.global_position.distance_to(building.global_position) > furthest_distance:
			furthest_citizen = citizen
			furthest_distance = citizen.global_position.distance_to(building.global_position)
	
	return furthest_citizen

func _on_spawn_delay_timeout():
	var furthest_citizen = get_furthest_citizen(get_tree().get_nodes_in_group("Citizen"), get_tree().get_first_node_in_group("Building"))
	var enemy = enemy_node.instantiate()
	enemy.global_position = furthest_citizen.global_position
	add_child(enemy)
