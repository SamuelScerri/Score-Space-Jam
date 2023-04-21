extends CharacterBody2D

@export_subgroup("Movement")
@export var movement_speed: int = 64
@export var difference_between_move: int = 96

@export_subgroup("Randomness")
@export var stray_angle_max: int = 60
@export var stray_angle_min: int = 60
@export var stop_straying_distance: int = 128

var building_target
var destination

func pick_random_building(buildings: Array):
	return buildings[randi_range(0, buildings.size() - 1)]

func _ready():
	#The Enemy Will Pick A Random Building, This Will Never Change
	building_target = pick_random_building(get_tree().get_nodes_in_group("Building"))
	destination = global_position
	change_destination()

func _physics_process(_delta):
	if global_position.distance_to(destination) < .1:
		change_destination()
		
	var difference = (destination - global_position).normalized()
	velocity = difference * movement_speed
	move_and_slide()
	
	check_for_collision()

#Here We Pick A Random Destination That Is Close To The Building
func change_destination():
	#Get The Direction Difference
	var direction = (building_target.global_position - global_position).normalized()
	
	#If The Enemy Is Close To The Building, They Will Stop Zig-Zagging And Make A Bee-Line For It
	if global_position.distance_to(building_target.global_position) < stop_straying_distance:
		destination = building_target.global_position
	
	#Here We Get The Angle Of The Difference, And Randomize It A Bit To Give A Sort Of Zig-Zag Movement
	else:
		var angle = direction.angle() + deg_to_rad(randf_range(-stray_angle_min, stray_angle_max))
		destination = global_position + Vector2(cos(angle), sin(angle)) * difference_between_move

func check_for_collision():
	if get_slide_collision_count() != 0:
		queue_free()
