extends "res://levels/base_level/base_level.gd"


func _on_hug_finished(body_a, body_b):
	if body_b.is_in_group("player"):
		_add_to_score(body_a.id, 1)


func playable(n_players):
	return n_players > 2
