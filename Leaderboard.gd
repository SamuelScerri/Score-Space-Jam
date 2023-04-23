extends ScrollContainer

var leaderboardDisplayed: bool = false

@export var information_template: PackedScene

func _ready():
	Leaderboard._authentication_request()

func _process(_delta):
	if Leaderboard.leaderboardInformation != null and not leaderboardDisplayed:
		for n in Leaderboard.leaderboardInformation.items.size():
			var information = information_template.instantiate()
			information.set_information(str(Leaderboard.leaderboardInformation.items[n].player.name), str(Leaderboard.leaderboardInformation.items[n].score))
			$Container.add_child(information)
			#leaderboardFormatted += str(json.items[n].rank)+str(". ")
			#leaderboardFormatted += str(json.items[n].player.id)+str(" - ")
			#leaderboardFormatted += str(json.items[n].score)+str("\n")
		
		$AnimationPlayer.play("Show")
		leaderboardDisplayed = true
