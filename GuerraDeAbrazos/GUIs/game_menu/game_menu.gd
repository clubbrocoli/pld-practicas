extends Control


func _input(event):
	if event.is_action_pressed("gui_menu"):
		if visible:
			close_menu()
		else:
			open_menu()
	elif event.is_action_pressed("gui_cancel_joy"):
		if visible:
			close_menu()


func _on_Continue_pressed():
	close_menu()


func _on_Quit_pressed():
	close_menu()
	get_tree().change_scene("res://GUIs/title_screen/title_screen.tscn")


func open_menu():
	get_tree().paused = true
	$VBoxContainer/Continue.grab_focus()
	show()


func close_menu():
	get_tree().paused = false
	hide()
