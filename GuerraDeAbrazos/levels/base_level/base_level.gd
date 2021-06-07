extends Node


signal finished(extra_scores)

const Player = preload("res://actors/player/player.tscn")

export var enable_time_limit: bool = true
export var initial_score: int = 0

onready var level_song = load("res://assets/music/arcade_fast_flow.ogg")

var scores: Array
var extra_scores: Array
var score_obj_str: String


func init(devices, textures):
	for i in devices.size():
		var player = Player.instance()
		player.id = i
		player.device_id = devices[i]
		player.position = $Respawns.get_child(i).position
		player.get_node("Sprite").set_texture(textures[i])
		player.connect("hug_finished", self, "_on_hug_finished")
		$YSort/Players.add_child(player)
		
		$GUI.show_score(i)
		$GUI.update_score(i, initial_score)
		scores.append(initial_score)
		extra_scores.append(0)


func _ready():
	MusicPlayer.play_song(level_song)


func _process(_delta):
	if not $TimeLimit.is_stopped():
		$GUI/TimeLeft.set_text(String(ceil($TimeLimit.time_left)))


func _on_IntroDuration_timeout():
	$GUI.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	if enable_time_limit:
		$TimeLimit.start()


func _on_TimeLimit_timeout():
	_end_level()


# Overwrite this function to change what counts as a level point
func _on_hug_finished(body_a, body_b):
	if body_b.is_in_group("npcs"):
		_add_to_score(body_a.id, 1)


# Returns wether this level is playable with a specific number of players
# Useful to overwrite in child script
func playable(_n_players):
	return true


func _add_to_score(player_idx: int, score_change: int):
	scores[player_idx] += score_change
	$GUI.update_score(player_idx, scores[player_idx])


# Overwrite this function to change win condition / win points
func _score_wins(score):
	if score == scores.max():
		return 1
	else:
		return 0


func _end_level():
	for i in scores.size():
		extra_scores[i] += _score_wins(scores[i])
	
	emit_signal("finished", extra_scores)
	queue_free()
