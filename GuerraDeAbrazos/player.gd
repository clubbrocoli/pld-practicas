extends KinematicBody2D

export var max_speed = 1000
export var accel = 2700
export var friction = 100

export(float) var bounce_treshold = 0.3
export(float) var bounce_factor = 0.6

var vel = Vector2.ZERO
var input = Vector2.ZERO
var was_on_wall = false

func _physics_process(delta):
	get_input()
	
	# Calculate velocity
	if input == Vector2.ZERO:
		vel = vel.linear_interpolate(Vector2.ZERO, 2 * delta)
	else:
		var extra_vel = input * accel * delta
		vel += extra_vel
		if vel.length() > max_speed:
			vel = vel.move_toward(vel.normalized() * max_speed, friction * delta + extra_vel.length())
	
	# Move and bounce / slide with velocity
	if vel.length() > max_speed * bounce_treshold && !was_on_wall:
		var collision = move_and_collide(vel * delta)
		if collision:
			vel = vel.bounce(collision.normal) * bounce_factor
	else:
		vel = move_and_slide(vel, Vector2.ZERO)
	
	was_on_wall = is_on_wall()

func get_input():
	input.x = Input.get_action_strength("mv_right") - Input.get_action_strength("mv_left")
	input.y = Input.get_action_strength("mv_down") - Input.get_action_strength("mv_up")
	input = input.normalized()
