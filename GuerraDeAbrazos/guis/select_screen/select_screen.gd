extends Control


enum Devices {JOY_0, JOY_1, JOY_2, JOY_3, KEY_1, KEY_2}

const ACTIVE_COLOR = Color(1, 1, 1, 1)
const INACTIVE_COLOR = Color(0.8, 0.8, 0.8, 0.6)
const LevelManager = preload("res://level_manager.tscn")

export var max_players = 4
export var min_players = 2

var devices: Array = []
var textures: Array = []
var disconnected_players: Array = []


func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	
	for i in max_players:
		devices.append(null)
		textures.append(null)
		disconnected_players.append(i)


func _input(event):
	var device_id = null
	
	# Check for join/leave by pressing START
	if event.is_action_pressed("start_joypad"):
		device_id = event.get_device()
	elif event.is_action_pressed("start_keyboard_1"):
		device_id = Devices.KEY_1
	elif event.is_action_pressed("start_keyboard_2"):
		device_id = Devices.KEY_2
	
	if device_id != null:
		if device_id in devices:
			remove_player(device_id)
		elif not disconnected_players.empty():
			add_player(device_id)
	
	# Check for leave by pressing EXIT or CANCEL
	if event.is_action_pressed("gui_menu") or event.is_action_pressed("gui_cancel_joy"):
		if get_tree().change_scene("res://guis/title_screen/title_screen.tscn") != OK:
			print("Unexpected error switching to TitleScreen scene")
	
	# Start game
	if _beginnable() and event.is_action_pressed("gui_accept"):
		# Clean Arrays
		var null_idx = devices.find(null)
		while null_idx != -1:
			devices.remove(null_idx)
			textures.remove(null_idx)
			null_idx = devices.find(null)
		
		# Instance level manager and free select_screen
		var level_manager = LevelManager.instance()
		level_manager.init(devices, textures)
		get_tree().get_root().add_child(level_manager)
		get_tree().set_current_scene(level_manager)
		queue_free()


func _on_joy_connection_changed(device_id, connected):
	if not connected and devices.has(device_id):
		remove_player(device_id)


func add_player(device_id):
	var player_id = disconnected_players.pop_front()
	devices[player_id] = device_id
	
	var player_panel = $Select/CenterRow.get_child(player_id)
	player_panel.get_node("Label").visible = false
	player_panel.get_node("Sprite").set_modulate(ACTIVE_COLOR)
	textures[player_id] = player_panel.get_node("Sprite").get_texture()
	
	if _beginnable():
		$Select/BeginHint/Label.text = "STARTTIP"


func remove_player(device_id):
	var player_id = devices.find(device_id)
	
	devices[player_id] = null
	disconnected_players.append(player_id)
	disconnected_players.sort()
	
	var player_panel = $Select/CenterRow.get_child(player_id)
	player_panel.get_node("Label").visible = true
	player_panel.get_node("Sprite").set_modulate(INACTIVE_COLOR)
	textures[player_id] = null
	
	if not _beginnable():
		$Select/BeginHint/Label.text = "BACKTIP"
		


func _beginnable():
	return disconnected_players.size() <= max_players - min_players
