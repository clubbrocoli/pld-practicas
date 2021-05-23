extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 40

var path: = PoolVector2Array()
var last_input = Vector2.ZERO
var direction = Vector2.ZERO
var animation

func start(given_path,starting_position):
	animation = "run"
	path = given_path
	position = starting_position
	direction = position.direction_to(path[0])


func _physics_process(delta):
	var distance_to_next_point = position.distance_to(path[0])
	if distance_to_next_point > 1:
		move_and_slide(direction*speed)
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			move_and_slide(direction.rotated(PI*randf())*speed*rand_range(1,3))
			direction = position.direction_to(path[0])	
					
		last_input = direction	
		change_animation(animation)
	else:
		# The player get to the next point
		last_input = direction
		change_animation(animation)
		path.remove(0)
		if path.size() <= 0:
			queue_free()
		else:
			direction = position.direction_to(path[0])	

func change_animation(animation):
	match animation:
		"idle":
			$AnimationTree.get("parameters/playback").travel("Idle")
		"run":
			$AnimationTree.set("parameters/Idle/blend_position", last_input)
			$AnimationTree.set("parameters/Run/blend_position", last_input)
			$AnimationTree.get("parameters/playback").travel("Run")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
