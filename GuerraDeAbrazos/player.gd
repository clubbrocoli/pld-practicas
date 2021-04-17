extends KinematicBody2D

export var max_speed = 1000
export var accel = 2700
export var friction = 1000

var motion = Vector2.ZERO
var input = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	get_input()

	if input == Vector2.ZERO:
		apply_friction(delta)
		animationState.travel("Idle")
	else:
		apply_movement(delta)
		animationTree.set("parameters/Idle/blend_position", input)
		animationTree.set("parameters/Run/blend_position", input)
		animationState.travel("Run")
	
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
	if motion.length() > max_speed * delta:
		motion = motion.move_toward(motion.normalized() * max_speed * delta, friction * delta + movement.length())
