extends CharacterBody2D

@export_subgroup("Movement")
@export var movement_speed: int = 96
@export var difference_between_move: int = 96

@export_subgroup("Randomness")
@export var stray_angle_max: int = 360
@export var stray_angle_min: int = 360
@export var stop_straying_distance: int = 128

var destination
var buildings

var dead: bool = false
var in_view: bool = false

func _ready():
	buildings = get_tree().get_nodes_in_group("Building")
	destination = global_position
	change_destination()

func _process(delta):
	if in_view:
		if Input.is_action_just_pressed("Fire"):
			die()

func _physics_process(_delta):
	if not dead:
		if global_position.distance_to(destination) < 1:
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
		
		#Here The Citizen Will Avoid Buildings
		for building in buildings:
			if global_position.distance_to(building.global_position) < stop_straying_distance:
				destination = global_position + (global_position - building.global_position).normalized() * difference_between_move / 2
				break
		
		var difference = (destination - global_position).normalized()
		velocity = velocity.move_toward(difference * movement_speed, 4)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 8)
	
	move_and_slide()

#Here We Pick A Random Destination That Is Close To The Building
func change_destination():
	var found = false
	
	if not found:
		#Here We Get The Angle Of The Difference, And Randomize It A Bit To Give A Sort Of Zig-Zag Movement
		var angle = deg_to_rad(randf_range(-stray_angle_min, stray_angle_max))
		destination = global_position + Vector2(cos(angle), sin(angle)) * difference_between_move

		

func die():
	if not dead:
		#Replace This Citizen
		Global.current_game_area.spawn_citizen()
		
		dead = true
		$Feedback.play("Death")
		velocity = Vector2(0, -320)


func _on_mouse_entered():
	in_view = true


func _on_mouse_exited():
	in_view = false
