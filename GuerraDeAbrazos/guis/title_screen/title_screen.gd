extends Control


onready var intro_song = preload("res://assets/music/intro.ogg")


func _ready():
	if not MusicPlayer.stream == intro_song:
		MusicPlayer.play_song(intro_song)
	$Menu/Buttons/Play.grab_focus()


func _on_Play_pressed():
	if get_tree().change_scene("res://guis/select_screen/select_screen.tscn") != OK:
		print("Unexpected error switching to SelectScreen scene")


func _on_Options_pressed():
	$OptionsMenu.open()


func _on_Quit_pressed():
	get_tree().quit()


func _input(event):
	if event.is_action_pressed("gui_menu") or event.is_action_pressed("gui_cancel_joy"):
		if $OptionsMenu.visible:
			$OptionsMenu.close()
			$Menu/Buttons/Play.grab_focus()
	
	if event is InputEventKey:
		$PlayableBackground/YSort/Players/Player.device_id = 4
	elif (event.is_action_pressed("mv_left_0") or event.is_action_pressed("mv_right_0") or 
		  event.is_action_pressed("mv_up_0") or event.is_action_pressed("mv_down_0") or 
		  event.is_action_pressed("dash_0") or event.is_action_pressed("bomb_0")):
		$PlayableBackground/YSort/Players/Player.device_id = event.get_device()
