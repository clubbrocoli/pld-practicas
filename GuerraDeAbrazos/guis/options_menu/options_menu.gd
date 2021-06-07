extends Control

onready var Settings = get_node("/root/Settings")


func _ready():
	$VBoxContainer/Fullscreen/Button.pressed = Settings.get_setting("display", "fullscreen")
	$VBoxContainer/Vsync/Button.pressed = Settings.get_setting("display", "vsync")
	$VBoxContainer/Language/OptionButton.selected = _locale_to_id(Settings.get_setting("input", "locale"))


func open():
	$VBoxContainer/Fullscreen/Button.grab_focus()
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


func _on_OptionButton_item_selected(index):
	match index:
		0:
			Settings.set_setting("input", "locale", "en")
		1:
			Settings.set_setting("input", "locale", "es")
	
	Settings.apply_settings()
	Settings.save_settings()


func _locale_to_id(locale: String):
	match locale:
		"en":
			return 0
		"es":
			return 1
