extends Control


var scores: Array


func init(scores):
	self.scores = scores

func _ready():
	$Label.text = String(scores)
