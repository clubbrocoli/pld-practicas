extends Control


var _scores: Array


func init(scores):
	_scores = scores

func _ready():
	$Label.text = String(_scores)
