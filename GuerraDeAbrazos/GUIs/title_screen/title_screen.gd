extends Control

func _ready():
	$Menu/CenterRow/Buttons/Play.grab_focus()

func _on_Play_pressed():
	get_tree().change_scene("res://GUIs/select_screen/select_screen.tscn")


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()

func _input(event):
	if event is InputEventKey:
		$PlayableBackground/YSort/Players/Player.device_id = 4
	elif (event.is_action_pressed("mv_left_0") or event.is_action_pressed("mv_right_0") or 
		  event.is_action_pressed("mv_up_0") or event.is_action_pressed("mv_down_0") or 
		  event.is_action_pressed("dash") or event.is_action_pressed("bomb")):
		$PlayableBackground/YSort/Players/Player.device_id = event.get_device()
