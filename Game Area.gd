extends Node

var score: int = 0

@onready var user_interface = $Interface
@onready var camera = $Camera
@onready var shake_duration = $Shake

@export var max_citizens_in_area = 16
@export var enemy_chance_percentage = .2

@export var citizen_node: PackedScene
@export var enemy_node: PackedScene

var should_shake = false
var game_ended = false

var citizen_enemy

func _ready():
	Global.current_game_area = self
	print("CITIZEN")
	citizen_enemy = user_interface.get_citizen()
	
	get_tree().paused = true
	
	#We Will Now Create A Bunch Of Citizens
	for i in range(max_citizens_in_area):
		spawn_citizen()

func add_score(amount):
	score += amount
	
	if score < 0:
		score = 0
	
	if amount > 0:
		user_interface.update_score_label(score, true)
	else:
		user_interface.update_score_label(score, false)

func shake_camera(strength):
	camera.offset = Vector2(randi_range(-strength, strength), randi_range(-strength, strength))

func spawn_citizen():
	var citizen = citizen_node.instantiate()
	var x_or_y = randi_range(0, 1)
	
	if x_or_y == 0:
		citizen.global_position = Vector2(randi_range(0, 1024), randi_range(0, 1) * 768)
	else:
		citizen.global_position = Vector2(randi_range(0, 1) * 1024, randi_range(0, 768))
	
	add_child(citizen)

func respawn_citizen():
	var furthest_citizen = get_furthest_citizen(get_tree().get_nodes_in_group("Citizen"), get_tree().get_first_node_in_group("Building"))
	var citizen = citizen_node.instantiate()
	citizen.global_position = furthest_citizen.global_position
	add_child(citizen)

func start_game():
	get_tree().paused = false
	print("Starting Game")

func do_shake():
	should_shake = true
	shake_duration.start()

func end_game():
	user_interface.show_end()
	game_ended = true

func _process(delta):
	if Input.is_action_just_pressed("Fire") and not game_ended:
		do_shake()
		
		$Fire.play()
	
	if should_shake:
		shake_camera(4)

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


func _on_shake_timeout():
	should_shake = false
	camera.offset = Vector2.ZERO
