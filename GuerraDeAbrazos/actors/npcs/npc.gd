extends KinematicBody2D


export var speed = 40
export var friction = 1500
export var hug_push = 500

var path: = PoolVector2Array()
var impulse_vel = Vector2.ZERO
var last_input = Vector2.ZERO
var direction = Vector2.ZERO
var hugging = false
var hugging_body = null
var animation
var pushed = false


func start(given_path, starting_position):
	animation = "run"
	path = given_path
	position = starting_position
	direction = position.direction_to(path[0])


func _physics_process(delta):
	if impulse_vel != Vector2.ZERO:
		move_and_slide(impulse_vel)
		impulse_vel = impulse_vel.move_toward(Vector2.ZERO, friction * delta)
		pushed = true
	elif pushed:
		pushed = false
		direction = position.direction_to(path[0])
	else:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_next_point > 1:
			move_and_slide(direction * speed)
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


func hug(body):
	if not hugging and (not body.hugging or body.hugging_body == self):
		hugging = true
		hugging_body = body
		set_physics_process(false)
		set_process_input(false)
		body.hug(self)
		
		
		$AnimationTree.set("parameters/Idle/blend_position", position.direction_to(body.position))
		change_animation("idle")
		$HugDuration.start()


func _on_HugDuration_timeout():
	impulse_vel = hugging_body.position.direction_to(position) * hug_push
	set_physics_process(true)
	set_process_input(true)
	$HugUnvulnerability.start()


func _on_HugUnvulnerability_timeout():
	hugging = false
	hugging_body = null

func change_animation(animation):
	match animation:
		"idle":
			$AnimationTree.get("parameters/playback").travel("Idle")
		"run":
			$AnimationTree.set("parameters/Idle/blend_position", last_input)
			$AnimationTree.set("parameters/Run/blend_position", last_input)
			$AnimationTree.get("parameters/playback").travel("Run")

# Disabling this for now, too many bugs with NPCs moving out of place
#func apply_impulse(impulse):
#	impulse_vel += impulse
