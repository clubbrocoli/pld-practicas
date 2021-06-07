tool

extends CanvasLayer

export var lives: bool = false

onready var star_icon = load("res://assets/gui/star.png")
onready var heart_icon = load("res://assets/gui/heart.png")


func _ready():
	_change_icon()


func _process(delta):
	if Engine.editor_hint:
		_change_icon()


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


func show_score(player: int):
	match player:
		0:
			$Margin/TopRow/Player1/Icon.show()
			$Margin/TopRow/Player1/Label.show()
		1:
			$Margin/TopRow/Player2/Icon.show()
			$Margin/TopRow/Player2/Label.show()
		2:
			$Margin/BottomRow/Player3/Icon.show()
			$Margin/BottomRow/Player3/Label.show()
		3:
			$Margin/BottomRow/Player4/Icon.show()
			$Margin/BottomRow/Player4/Label.show()


func update_score(player: int, score: int):
	match player:
		0:
			$Margin/TopRow/Player1/Label.text = "x " + String(score)
		1:
			$Margin/TopRow/Player2/Label.text = "x " + String(score)
		2:
			$Margin/BottomRow/Player3/Label.text = "x " + String(score)
		3:
			$Margin/BottomRow/Player4/Label.text = "x " + String(score)


func _change_icon():
	if lives:
		$Margin/TopRow/Player1/Icon.texture = heart_icon
		$Margin/TopRow/Player2/Icon.texture = heart_icon
		$Margin/BottomRow/Player3/Icon.texture = heart_icon
		$Margin/BottomRow/Player4/Icon.texture = heart_icon
	else:
		$Margin/TopRow/Player1/Icon.texture = star_icon
		$Margin/TopRow/Player2/Icon.texture = star_icon
		$Margin/BottomRow/Player3/Icon.texture = star_icon
		$Margin/BottomRow/Player4/Icon.texture = star_icon
