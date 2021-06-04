extends CanvasLayer


export var lives: bool = false

func _input(event):
	if $GameMenu.visible and event.is_action_pressed("gui_menu") or event.is_action_pressed("gui_cancel_joy"):
		if $OptionsMenu.visible:
			$OptionsMenu.close()
			$GameMenu.open()
		else:
			$GameMenu.close()
	elif event.is_action_pressed("gui_menu"):
		$GameMenu.open()


func _on_GameMenu_options_pressed():
	$OptionsMenu.open()
