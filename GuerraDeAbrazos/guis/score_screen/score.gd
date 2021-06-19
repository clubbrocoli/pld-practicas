extends Control


func init(score, sprite, winner=false):
	$ScoreLabel.text = str(score)
	$Sprite.set_texture(sprite)
	$WinnerParticles.emitting = winner
