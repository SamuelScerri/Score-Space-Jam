extends CharacterBody2D

@export var damage: int = 10
@export var score_enemy: int = 10
@export var score_innocent: int = -20

@export_subgroup("Movement")
@export var movement_speed: int = 96
@export var difference_between_move: int = 96

@export_subgroup("Randomness")
@export var stray_angle: int = 75
@export var stop_straying_distance: int = 128

var destination: Vector2
var dead: bool = false
var in_view: bool = false

func spawned():
	$Animator.play("Move")

func generate_character():
	$Character.generate_clothes()

func _ready():
	change_destination(Global.get_current_game_area().building.global_position)

func _process(_delta):
	move_and_slide()
	
	if Input.is_action_just_pressed("Fire") and in_view and Global.get_current_game_area().game_running:
		die()

func _physics_process(_delta):
	if not dead:
		process_citizen()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 8)

func process_citizen():
	if global_position.distance_to(destination) <= 1:
		change_destination(Global.get_current_game_area().building.global_position)
	
	destination = check_boundaries(destination)
	
	#The Citizen Will Only Avoid The Building If It's Innocent
	destination = check_building(destination, Global.get_current_game_area().building.global_position)
	
	if $Character.has_enemy_clothes() and Global.get_current_game_area().game_running:
		check_collisions()
	
	var difference = (destination - global_position).normalized()
	velocity = velocity.move_toward(difference * movement_speed, 4)

func die():
	if not dead:
		dead = true
		$Animator.play("Death")
		
		if $Character.has_enemy_clothes():
			Global.get_current_game_area().add_score(score_enemy)
		else:
			Global.get_current_game_area().add_score(score_innocent)
		velocity = Vector2(0, -320)

func get_character():
	return $Character

#The Citizen Will Move Away From The Area
func check_boundaries(old_destination: Vector2):
	var direction = Vector2.ZERO
	
	if global_position.x < 32:
		direction.x = 1
	elif global_position.x > 992:
		direction.x = -1
		
	if global_position.y < 32:
		direction.y = 1
	elif global_position.y > 736:
		direction.y = -1
	
	if direction != Vector2.ZERO:
		return global_position + direction.normalized() * difference_between_move * 2
	
	return old_destination

func check_building(old_destination: Vector2, building: Vector2):
	if global_position.distance_to(building) <= stop_straying_distance:
		if not $Character.has_enemy_clothes() or not Global.get_current_game_area().game_running:
			return global_position + (global_position - building).normalized()
		else:
			return building
	
	return old_destination

#Here We Change The Destination, If It's An Enemy It Will Zig Zag Towards The Building, The Citizen Will Run Around Aimlessly
func change_destination(building_target: Vector2):
	var angle = 0
	
	if $Character.has_enemy_clothes() and Global.get_current_game_area().game_running:
		var direction = (building_target - global_position).normalized()
		angle = direction.angle() + deg_to_rad(randf_range(-stray_angle, stray_angle))
	else:
		angle = deg_to_rad(randf_range(-360, 360))
	destination = global_position + Vector2(cos(angle), sin(angle)) * difference_between_move

func check_collisions():
	if get_slide_collision_count() != 0:
		Global.get_current_game_area().building.damage(damage)
		queue_free()


func mouse_entered():
	in_view = true


func mouse_exited():
	in_view = false
