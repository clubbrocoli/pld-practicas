extends Control


enum Devices {JOY_0, JOY_1, JOY_2, JOY_3, KEY_1, KEY_2}

const ACTIVE_COLOR = Color(1, 1, 1, 1)
const INACTIVE_COLOR = Color(0.8, 0.8, 0.8, 0.6)
const GameScene = preload("res://levels/test_map.tscn")

export var max_players = 4

var device_mapping = {}
var disconnected_players: Array = []
var textures: Array = []


func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	
	for i in max_players:
		disconnected_players.append(i)
		textures.append('')


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
		if device_id in device_mapping:
			remove_player(device_id)
		elif device_mapping.size() < max_players:
				add_player(device_id)
	
	# Check for leave by pressing CANCEL
	if event.is_action_pressed("gui_cancel_joy"):
		device_id = event.get_device()
		if device_id in device_mapping:
			remove_player(device_id)
	
	# Start game
	if device_mapping.size() > 1 and event.is_action_pressed("gui_accept"):
		var game_scene = GameScene.instance()
		game_scene.init_players(device_mapping, textures)
		get_tree().get_root().add_child(game_scene)
		get_tree().set_current_scene(game_scene)
		get_tree().get_root().get_node("SelectScreen").queue_free()


func _on_joy_connection_changed(device_id, connected):
	if not connected and device_mapping.has(device_id):
		remove_player(device_id)


func add_player(device_id):
	var player_id = disconnected_players.pop_front()
	device_mapping[device_id] = player_id
	
	var player_panel = $Select/CenterRow.get_child(player_id)
	player_panel.get_node("Label").visible = false
	player_panel.get_node("Sprite").set_modulate(ACTIVE_COLOR)
	textures[player_id] = player_panel.get_node("Sprite").get_texture()
	
	if device_mapping.size() > 1:
		$Select/BeginHint/Label.visible = true


func remove_player(device_id):
	var player_id = device_mapping[device_id]
	device_mapping.erase(device_id)
	disconnected_players.append(player_id)
	disconnected_players.sort()
	
	var player_panel = $Select/CenterRow.get_child(player_id)
	player_panel.get_node("Label").visible = true
	player_panel.get_node("Sprite").set_modulate(INACTIVE_COLOR)
	textures[player_id] = ''
	
	if device_mapping.size() <= 1:
		$Select/BeginHint/Label.visible = false
