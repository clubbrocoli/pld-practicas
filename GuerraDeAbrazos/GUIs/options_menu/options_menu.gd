extends Control

onready var Settings = get_node("/root/Settings")


func _ready():
	$VBoxContainer/Fullscreen.pressed = Settings.get_setting("display", "fullscreen")
	$VBoxContainer/Vsync.pressed = Settings.get_setting("display", "vsync")


func open():
	$VBoxContainer/Fullscreen.grab_focus()
	show()


func close():
	hide()


func _on_Fullscreen_toggled(button_pressed):
	Settings.set_setting("display", "fullscreen", button_pressed)
	Settings.apply_settings()
	Settings.save_settings()


func _on_Vsync_toggled(button_pressed):
	Settings.set_setting("display", "vsync", button_pressed)
	Settings.apply_settings()
	Settings.save_settings()
