extends CharacterBody2D

@export_subgroup("Movement")
@export var movement_speed: int = 96
@export var difference_between_move: int = 96

@export_subgroup("Randomness")
@export var stray_angle_max: int = 60
@export var stray_angle_min: int = 60
@export var stop_straying_distance: int = 128

var building_target
var destination

var dead: bool = false

func pick_random_building(buildings: Array):
	return buildings[randi_range(0, buildings.size() - 1)]

func _ready():
	#The Enemy Will Pick A Random Building, This Will Never Change
	building_target = pick_random_building(get_tree().get_nodes_in_group("Building"))
	destination = global_position
	change_destination()

func _physics_process(_delta):
	if not dead:
		check_for_collision()
		
		#If The Enemy Is Close To The Building, They Will Stop Zig-Zagging And Make A Bee-Line For It
		if global_position.distance_to(building_target.global_position) < stop_straying_distance:
			destination = building_target.global_position
		
		elif global_position.distance_to(destination) < 1:
			change_destination()
		
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
	dead = true
	$Feedback.play("Death")
	velocity = Vector2(0, -320)
