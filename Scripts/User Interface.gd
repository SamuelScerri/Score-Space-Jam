extends Node

func start_game():
	$Animator.play("Begin")
	$Select.play()

	Global.current_game_area.start_game()

func update_score_label(score, positive: bool):
	if not positive:
		$Animator.play("Red Flash")
	else:
		$Animator.play("Green Flash")
	
	$Label.text = str(score)
