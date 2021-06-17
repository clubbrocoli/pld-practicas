extends Node


const ScoreScreen = preload("res://guis/score_screen/score_screen.tscn")

export var score_objective: int = 3
export var max_levels: int = 3

var _scores: Array
var _devices: Array
var _textures: Array
var _levels: Array
var _current_level: int = 0
var _levels_played: int = 0


func init(devices, textures):
	_devices = devices
	_textures = textures
	for i in _devices.size():
		_scores.append(0)


func _ready():
	_generate_level_list()
	_load_next_level()


func get_scores_dict(score,texture):
	var dict = []
	for i in range(len(score)):
		dict.append({"score": score[i] , "texture": texture[i]})
		
	return dict

func _on_Level_finished(extra_scores):
	# Update Scores
	for i in _scores.size():
		_scores[i] += extra_scores[i]

	# Check for conditions to end game
	for score in _scores:
		if score_objective != 0 and score >= score_objective:
			_end_game()
	
	if max_levels != 0 and _levels_played >= max_levels:
		_end_game()
	
	var scores_screen = ScoreScreen.instance()
	var scores_dict = get_scores_dict(_scores,_textures)
	scores_screen.init(scores_dict, false, self)
	get_tree().get_root().add_child(scores_screen)
	get_tree().set_current_scene(scores_screen)
	


func _generate_level_list():
	var dir = Directory.new()
	if dir.open("res://levels/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				_levels.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	_levels.shuffle()


func _load_next_level():
	_current_level += 1
	
	if _current_level >= _levels.size():
		_levels.shuffle()
		_current_level = 0
	
	var level = load("res://levels/" + _levels[_current_level]).instance()
	
	if level.playable(_devices.size()):
		_levels_played += 1
		level.init(_devices, _textures)
		level.connect("finished", self, "_on_Level_finished")
		get_tree().set_current_scene(level)
		add_child(level)
	else:
		_load_next_level()


func _end_game():
	# Instance _scores screen and free self
	var scores_screen = ScoreScreen.instance()
	var scores_dict = get_scores_dict(_scores,_textures)
	scores_screen.init(scores_dict, false, self)
	get_tree().get_root().add_child(scores_screen)
	get_tree().set_current_scene(scores_screen)
	queue_free()
