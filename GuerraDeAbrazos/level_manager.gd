extends Node


const ScoreScreen = preload("res://guis/score_screen/score_screen.tscn")

export var score_objective: int = 3
export var max_levels: int = 0

var scores: Array
var devices: Array
var textures: Array
var levels: Array
var current_level: int = 0
var levels_played: int = 0


func init(devices, textures):
	self.devices = devices
	self.textures = textures
	for i in devices.size():
		scores.append(0)


func set_end_conditions(score_objective, max_levels):
	self.score_objective = score_objective
	self.max_levels = max_levels


func _ready():
	_generate_level_list()
	_load_next_level()


func _on_Level_finished(extra_scores):
	# Update Scores
	for i in scores.size():
		scores[i] += extra_scores[i]

	# Check for conditions to end game
	for score in scores:
		if score_objective != 0 and score >= score_objective:
			_end_game()
	
	if max_levels != 0 and levels_played >= max_levels:
		_end_game()
	
	_load_next_level()


func _generate_level_list():
	var dir = Directory.new()
	if dir.open("res://levels/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				levels.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	levels.shuffle()


func _load_next_level():
	current_level += 1
	
	if current_level >= levels.size():
		levels.shuffle()
		current_level = 0
	
	var level = load("res://levels/" + levels[current_level]).instance()
	
	if level.playable(devices.size()):
		levels_played += 1
		level.init(devices, textures)
		level.connect("finished", self, "_on_Level_finished")
		add_child(level)
	else:
		_load_next_level()


func _end_game():
	# Instance scores screen and free self
	var scores_screen = ScoreScreen.instance()
	scores_screen.init(scores)
	get_tree().get_root().add_child(scores_screen)
	get_tree().set_current_scene(scores_screen)
	queue_free()
