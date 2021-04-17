extends KinematicBody2D

export var max_speed = 1000
export var accel = 2700
export var friction = 1000

var motion = Vector2.ZERO
var input = Vector2.ZERO
var was_on_wall = false

func _physics_process(delta):
	get_input()

	if input == Vector2.ZERO:
		apply_friction(delta)
	else:
		apply_movement(delta)
	
	motion = move_and_slide(motion, Vector2.ZERO)

func get_input():
	input.x = Input.get_action_strength("mv_right") - Input.get_action_strength("mv_left")
	input.y = Input.get_action_strength("mv_down") - Input.get_action_strength("mv_up")
	input = input.normalized()

func apply_friction(delta):
	motion = motion.move_toward(Vector2.ZERO, friction * delta)

func apply_movement(delta):
	var movement = input * accel * delta
	motion += movement
	if motion.length() > max_speed:
		motion = motion.move_toward(motion.normalized() * max_speed, friction * delta + movement.length())
