extends Control

const Score = preload("res://guis/score_screen/score.tscn")

var _scores: Array
var _players: Array
var _is_final: bool = false
var _level_manager
var positions


func init(scores, is_final, level_manager):
	_scores = scores
	_is_final = is_final
	_level_manager = level_manager
	positions = $ScorePositions.get_children()

func _input(event):
	var device_id = null
	
	# Check for join/leave by pressing START
	if event.is_action_pressed("start_joypad"):
		start()
	elif event.is_action_pressed("start_keyboard_1"):
		start()
	elif event.is_action_pressed("start_keyboard_2"):
		start()
	elif event.is_action_pressed("ui_cancel") and _is_final:
		back_to_menu()

func _ready():
	if(_is_final):
		$Help.text = "ENDGAMEHELP"
	else:
		$Help.text = "ENDLEVELHELP"
	
	_scores.sort_custom(self,"sort_scores")
	for i in range(_scores.size()):
		var score = Score.instance()
		var score_dict = _scores[i]
		score.init(score_dict['score'], score_dict['texture'], positions[i].position, i == 0)
		$Podium.add_child(score);
		
func start():
	if (_is_final):
		if get_tree().change_scene("res://guis/select_screen/select_screen.tscn") != OK:
			print("Unexpected error switching to SelectScreen scene")
	else:
		_level_manager._load_next_level()
	queue_free()
	
func back_to_menu():
	if get_tree().change_scene("res://guis/title_screen/title_screen.tscn") != OK:
		print("Unexpected error switching to TitleScreen scene")
	queue_free()
	
	

func sort_scores(a,b):
	return a['score'] > b['score']
