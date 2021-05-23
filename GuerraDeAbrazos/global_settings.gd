# Stores, saves, and loads game settings in an ini-style file

extends Node

const SAVE_PATH = "user://settings.cfg"

var _config_file = ConfigFile.new()

var _settings = {
	"display": {
		"fullscreen": true,
		"vsync": true,
	}
}


func _ready():
	load_settings()
	apply_settings()


func apply_settings():
	OS.set_window_fullscreen(_settings["display"]["fullscreen"])
	OS.set_use_vsync(_settings["display"]["vsync"])

func save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])

	_config_file.save(SAVE_PATH)


func load_settings():
	var error = _config_file.load(SAVE_PATH)
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		return 1

	for section in _settings.keys():
		for key in _settings[section].keys():
			var val = _config_file.get_value(section,key)
			if val != null:
				_settings[section][key] = val

	return 0


func get_setting(category, key):
	return _settings[category][key]


func set_setting(category, key, value):
	_settings[category][key] = value
