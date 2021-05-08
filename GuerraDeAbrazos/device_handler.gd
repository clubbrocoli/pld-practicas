extends Node

enum Devices {JOY_0, JOY_1, JOY_2, JOY_3, KEY_1, KEY_2}

var device_mapping = {}
var disconnected_players: Array = []
var player_scene = preload("res://actors/player/player.tscn")

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func _input(event):
	var device_id = null
	
	if event.is_action_pressed("start_joypad"):
		device_id = event.get_device()
	elif event.is_action_pressed("start_keyboard_1"):
		device_id = Devices.KEY_1
	elif event.is_action_pressed("start_keyboard_2"):
		device_id = Devices.KEY_2
	
	if device_id != null:
		if device_id in device_mapping:
			remove_player(device_id)
		else:
			if disconnected_players.empty():
				add_player(device_id)
			else:
				reconnect_player(device_id)

func _on_joy_connection_changed(device_id, connected):
	if not connected and device_mapping.has(device_id):
		disconnect_player(device_id)

func add_player(device_id):
	# Create player instance and save in array
	var p = player_scene.instance()
	p.start(device_mapping.size(), device_id, Vector2(350, 200))
	device_mapping[device_id] = p
	
	# Add player to current scene
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.get_node("YSort").add_child(p)

func remove_player(device_id):
	device_mapping[device_id].queue_free()
	device_mapping.erase(device_id)

func disconnect_player(device_id):
	var p = device_mapping.get(device_id)
	p.set_modulate(Color(0.8, 0.8, 0.8, 0.6))
	p.device_id = -2
	disconnected_players.append(p)
	device_mapping.erase(device_id)

func reconnect_player(device_id):
	var p = disconnected_players.pop_front()
	device_mapping[device_id] = p
	p.set_modulate(Color(1, 1, 1, 1))
	p.device_id = device_id
	device_mapping[device_id] = p
