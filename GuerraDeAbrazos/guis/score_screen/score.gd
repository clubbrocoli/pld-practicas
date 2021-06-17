extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _sprite
var _score
var _winner

func init( score, sprite, start_position, winner=false):
	_sprite = sprite
	_score = score
	_winner = winner
	self.position = start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.set_texture(_sprite)
	$ScoreLabel.text = str(_score)
	$WinnerParticles.emitting = _winner
	$WinnerParticles.amount = _score


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
