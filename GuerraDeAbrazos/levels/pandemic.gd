extends "res://levels/base_level/base_level.gd"

var n_players

func _ready():
	n_players = $YSort/Players.get_child_count()

func _on_hug_finished(body_a, _body_b):
	_add_to_score(body_a.id, -1)
	if scores[body_a.id] == 0:
		body_a.queue_free()
		n_players -= 1
		
		if n_players <= 1:
			$CachondeoDuration.start()


func _score_wins(score):
	if score > 0:
		return 1
	else:
		return 0


func _on_CachondeoDuration_timeout():
	_end_level()
