extends Node

func _on_text_edit_text_changed():
	Leaderboard.custom_name = $Name.text


func _on_leaderboard_pressed():
	#Leaderboard._authentication_request()
	$Animator.play("Show Leaderboard")


func _on_animator_animation_finished(anim_name):
	if anim_name == "Show Leaderboard":
		get_tree().change_scene_to_file("res://Nodes/Leaderboard/Leaderboard.tscn")
	elif anim_name == "Start Game":
		get_tree().change_scene_to_file("res://Game Area.tscn")

func _on_start_pressed():
	$Animator.play("Start Game")
