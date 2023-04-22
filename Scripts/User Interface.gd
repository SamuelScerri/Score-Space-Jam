extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	$Crosshair.global_position = get_viewport().get_mouse_position()

func start_game():
	$Animator.play("Begin")
	$Select.play()
	$Music.play()
	$Music/Crowd.play()
	

	Global.current_game_area.start_game()

func get_citizen():
	return $Target/Character

func update_score_label(score, positive: bool):
	if not positive:
		$Animator.play("Red Flash")
	else:
		$Animator.play("Green Flash")
	
	$Label.text = str(score)

func show_end():
	$Animator.play("End")
