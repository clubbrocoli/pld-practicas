extends Control

signal options_pressed


func _input(event):
	if event.is_action_pressed("gui_menu"):
		pass

func _on_Continue_pressed():
	close()


func _on_Settings_pressed():
	emit_signal("options_pressed")


func _on_Quit_pressed():
	close()
	if get_tree().change_scene("res://guis/title_screen/title_screen.tscn") != OK:
		print("Unexpected error changing scene to leave a match")


func open():
	get_tree().paused = true
	$VBoxContainer/Continue.grab_focus()
	show()


func close():
	get_tree().paused = false
	hide()


func _on_ExitDesktop_pressed():
	get_tree().quit()
