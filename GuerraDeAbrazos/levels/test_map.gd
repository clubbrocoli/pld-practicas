extends Node

enum Devices {JOY_0, JOY_1, JOY_2, JOY_3, KEY_1, KEY_2}

const Player = preload("res://actors/player/player.tscn")

var device_mapping
var disconnected_players = []


func init_players(d_mapping, textures):
	device_mapping = d_mapping
	var device_player = []
	
	# Move device_mapping dictionary to array to sort it
	for i in device_mapping.size():
		 device_player.append([device_mapping.values()[i], device_mapping.keys()[i]])
	device_player.sort_custom(self, "sort_device")
	
	# Instance players
	for ids in device_player:
		var player_id = ids[0]
		var device_id = ids[1]
		
		var player = Player.instance()
		player.id = player_id
		player.device_id = device_id
		player.position = $Respawns.get_child(player_id).position
		player.get_node("Sprite").set_texture(textures[player_id])
		
		$YSort/Players.add_child(player)
		player.connect("hug_finished", self, "_on_hug_finished")


func sort_device(a, b):
	return a[1] < b[1]


func _on_hug_finished(body_a, body_b):
	pass

# For changing controllers mid-game (Commented because signal is not consistent for now in disconects)
#func _ready():
#	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
#
#func _input(event):
#	var device_id = null
#
#	# Check for reconnect
#	if event.is_action_pressed("start_joypad"):
#		device_id = event.get_device()
#	elif event.is_action_pressed("start_keyboard_1"):
#		device_id = Devices.KEY_1
#	elif event.is_action_pressed("start_keyboard_2"):
#		device_id = Devices.KEY_2
#
#	if device_id != null:
#		if not device_id in device_mapping and !disconnected_players.empty():
#			reconnect_player(device_id)
#
#
#func _on_joy_connection_changed(device_id, connected):
#	if not connected and device_id in device_mapping:
#		disconnect_player(device_id)
#
#func disconnect_player(device_id):
#	var player_idx = device_mapping.get(device_id)
#	var p = $Ysort/Players.get_child(player_idx)
#	p.set_modulate(Color(0.8, 0.8, 0.8, 0.6))
#	p.device_id = -2
#	disconnected_players.append(p)
#	device_mapping.erase(device_id)
#
#func reconnect_player(device_id):
#	var p = disconnected_players.pop_front()
#	device_mapping[device_id] = p
#	p.set_modulate(Color(1, 1, 1, 1))
#	p.device_id = device_id
#	device_mapping[device_id] = p
