extends Node

@onready var building: StaticBody2D = get_tree().get_first_node_in_group("Building")

@export var spawn_amount: int = 16
@export var capped_spawn: int = 32

@export var citizen_node: PackedScene
@export var killed_enemies_until_change: int = 5

var game_running: bool = false
var enemy_clothes = null

var should_shake: bool = false
@onready var enemy_threshold: int = killed_enemies_until_change

var score: int = 0

func add_score(amount):
	score += amount
	
	if score < 0:
		score = 0
	
	if amount > 0:
		enemy_threshold -= 1
		
		#Switch Enemy & Increase Civilians
		if enemy_threshold <= 0:
			spawn_amount += 1
			if spawn_amount > capped_spawn:
				spawn_amount = capped_spawn
			
			enemy_threshold = killed_enemies_until_change
			$Interface.switch_enemy()
		
		$Interface.flash_and_update(true, score)
	else:
		$Interface.flash_and_update(false, score)

func _ready():
	Global.current_game_area = self
	get_tree().paused = true

func _process(_delta):
	if should_shake:
		$Camera.offset = Vector2(randi_range(-4, 4), randi_range(-4, 4))
	
	if game_running:
		if Input.is_action_just_pressed("Fire") and game_running:
			shake_camera()
			$Fire.play()

		#Count All Innocent Citizens
		var amount_of_innocents: int = 0
		for citizen in get_tree().get_nodes_in_group("Citizen"):
			if not citizen.get_character().has_enemy_clothes():
				amount_of_innocents += 1
		
		for i in range(spawn_amount - amount_of_innocents):
			spawn_citizen()

func end_game():
	game_running = false
	$Interface.show_end_screen()
	Leaderboard.score = score

func shake_camera():
	should_shake = true
	$Shake.start()

func start_game():
	#Spawn All Citizens
	for i in range(spawn_amount):
		spawn_citizen()
	
	game_running = true
	get_tree().paused = false

#Spawn Citizen From Boundaries Randomly
func spawn_citizen():
	var citizen = citizen_node.instantiate()
	
	var x_or_y = randi_range(0, 1)
	
	if x_or_y == 0:
		citizen.global_position = Vector2(randi_range(0, 1024), randi_range(0, 1) * 768)
	else:
		citizen.global_position = Vector2(randi_range(0, 1) * 1024, randi_range(0, 768))
	
	add_child(citizen)
	citizen.generate_character()

#Get Citizen Furthest Away From Building
func get_furthest_citizen(citizens: Array, building_target: Vector2):
	var furthest_citizen: CharacterBody2D = null
	var furthest_distance = 0
	
	for citizen in citizens:
		if !citizen.dead and !citizen.get_character().has_enemy_clothes():
			if furthest_distance == 0 or citizen.global_position.distance_to(building_target) > furthest_distance:
				furthest_citizen = citizen
				furthest_distance = citizen.global_position.distance_to(building_target)
	
	return furthest_citizen

#Spawn Enemy (AKA, Default Citizen Clothes)
func spawn_enemy():
	var furthest_citizen = get_furthest_citizen(get_tree().get_nodes_in_group("Citizen"), get_tree().get_first_node_in_group("Building").global_position)
	var enemy = citizen_node.instantiate()
	enemy.global_position = furthest_citizen.global_position
	add_child(enemy)

func stop_shaking():
	should_shake = false
	$Camera.offset = Vector2.ZERO
