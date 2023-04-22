extends CharacterBody2D

@export_subgroup("Movement")
@export var movement_speed: int = 96
@export var difference_between_move: int = 96

@export_subgroup("Randomness")
@export var stray_angle_max: int = 75
@export var stray_angle_min: int = 75
@export var stop_straying_distance: int = 128

var building_target
var destination

var dead: bool = false
var in_view: bool = false

func pick_random_building(buildings: Array):
	return buildings[randi_range(0, buildings.size() - 1)]

func _ready():
	#The Enemy Will Pick A Random Building, This Will Never Change
	building_target = pick_random_building(get_tree().get_nodes_in_group("Building"))
	destination = global_position
	change_destination()

func _process(delta):
	if in_view and not Global.current_game_area.game_ended:
		if Input.is_action_just_pressed("Fire"):
			die()

func _physics_process(_delta):
	if not dead:
		if not Global.current_game_area.game_ended:
			check_for_collision()
		
		#If The Enemy Is Close To The Building, They Will Stop Zig-Zagging And Make A Bee-Line For It
		if global_position.distance_to(building_target.global_position) < stop_straying_distance:
			destination = building_target.global_position
		
		elif global_position.distance_to(destination) < 1:
			change_destination()
			
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
			destination = global_position + direction.normalized() * difference_between_move / 2
		
		var difference = (destination - global_position).normalized()
		velocity = velocity.move_toward(difference * movement_speed, 4)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 8)
	
	move_and_slide()

#Here We Pick A Random Destination That Is Close To The Building
func change_destination():
	#Get The Direction Difference
	var direction = (building_target.global_position - global_position).normalized()
	
	var angle = direction.angle() + deg_to_rad(randf_range(-stray_angle_min, stray_angle_max))
	destination = global_position + Vector2(cos(angle), sin(angle)) * difference_between_move

func check_for_collision():
	if get_slide_collision_count() != 0:
		building_target.damage()
		queue_free()

func die():
	if not dead:
		dead = true
		Global.current_game_area.add_score(10)
		
		$Feedback.play("Death")
		velocity = Vector2(0, -320)


func _on_mouse_entered():
	in_view = true


func _on_mouse_exited():
	in_view = false
