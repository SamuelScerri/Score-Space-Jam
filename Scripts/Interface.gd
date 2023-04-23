extends Node

func _ready():
	$Polaroid/Character.generate_clothes()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func confirmed():
	$Animator.play("Start")
	Global.get_current_game_area().enemy_clothes = $Polaroid/Character
	Global.get_current_game_area().start_game()

func _process(_delta):
	pass

func flash_and_update(positive: bool, score: int):
	$Score.text = str(score)
	
	if positive:
		$Animator.play("Good Flash")
	else:
		$Animator.play("Red Flash")

func switch_enemy():
	$Polaroid/Animator.play("Switch")

func regenerate_enemy():
	$Polaroid/Character.generate_clothes()
	Global.get_current_game_area().enemy_clothes = $Polaroid/Character

func show_end_screen():
	$Animator.play("End Screen")
