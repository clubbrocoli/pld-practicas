extends CanvasLayer


func _ready():
	get_tree().paused = true
	$IntroDuration.start()


func _process(_delta):
	$VBoxContainer/Counter.set_text(String(ceil($IntroDuration.time_left)))


func _on_IntroDuration_timeout():
	$AnimationPlayer.play("slide_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "slide_out":
		get_tree().paused = false
		queue_free()
