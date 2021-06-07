extends Control

onready var fullscreen_checkbox = $VBoxContainer/Fullscreen/CheckBox
onready var vsync_checkbox = $VBoxContainer/Vsync/CheckBox
onready var language_option = $VBoxContainer/Language/OptionButton
onready var music_vol_slider = $VBoxContainer/MusicVol/HSlider
onready var sfx_vol_slider = $VBoxContainer/SfxVol/HSlider

func _ready():
	fullscreen_checkbox.pressed = Settings.get_setting("display", "fullscreen")
	vsync_checkbox.pressed = Settings.get_setting("display", "vsync")
	language_option.selected = _locale_to_id(Settings.get_setting("input", "locale"))
	music_vol_slider.value = Settings.get_setting("audio", "music_volume")
	sfx_vol_slider.value = Settings.get_setting("audio", "sfx_volume")

func open():
	fullscreen_checkbox.grab_focus()
	show()


func close():
	Settings.save_settings()
	hide()


func _on_Fullscreen_toggled(button_pressed):
	Settings.set_setting("display", "fullscreen", button_pressed)
	Settings.apply_settings()
	


func _on_Vsync_toggled(button_pressed):
	Settings.set_setting("display", "vsync", button_pressed)
	Settings.apply_settings()


func _on_Language_item_selected(index):
	match index:
		0:
			Settings.set_setting("input", "locale", "en")
		1:
			Settings.set_setting("input", "locale", "es")
	Settings.apply_settings()


func _locale_to_id(locale: String):
	match locale:
		"en":
			return 0
		"es":
			return 1


func _on_MusicVol_value_changed(value):
	Settings.set_setting("audio", "music_volume", value)
	Settings.apply_settings()


func _on_SfxVol_value_changed(value):
	Settings.set_setting("audio", "sfx_volume", value)
	Settings.apply_settings()
