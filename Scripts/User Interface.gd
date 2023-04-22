extends Node

func start_game():
	$Animator.play("Begin")

	Global.current_game_area.start_game()
