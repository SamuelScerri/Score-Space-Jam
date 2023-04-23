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


func to_main_menu():
	$Animator.play("Go To Main Menu")
	$Confirm2.play()


func to_leaderboard():
	$Animator.play("Go To Leaderboards")
	$Confirm2.play()


func _on_animator_animation_finished(anim_name):
	if anim_name == "Go To Main Menu":
		get_tree().change_scene_to_file("res://Main Menu.tscn")
	elif anim_name == "Go To Leaderboards":
		get_tree().change_scene_to_file("res://Nodes/Leaderboard/Leaderboard.tscn")


func _on_button_3_pressed():
	if $Button4.text.length() > 0:
		Leaderboard._change_player_name($Button4.text)
	
	$Confirm2.play()
	$Animator.play("Go To Leaderboards")
