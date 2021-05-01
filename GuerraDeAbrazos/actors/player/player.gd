extends KinematicBody2D

# Movement constants
export var max_speed = 200
export var accel = 1000
export var friction = 1000

# Bomb constants
export var bomb_distance = 15
export var bomb_speed = 100
export var bomb_push = 700
export var bomb_mov_reduction = 0.4
export var bomb_mov_red_threshold = 0.4

var velocity = Vector2.ZERO
var impulse_vel = Vector2.ZERO
var input = Vector2.ZERO
var last_input = Vector2.ZERO

var Bullet = preload("res://actors/player/bomb.tscn")

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
		last_input = input
		animationTree.set("parameters/Idle/blend_position", last_input)
		animationTree.set("parameters/Run/blend_position", last_input)
		animationState.travel("Run")
	
	impulse_vel = impulse_vel.move_toward(Vector2.ZERO, friction * delta)
	if impulse_vel == Vector2.ZERO:
		velocity = move_and_slide(velocity, Vector2.ZERO)
	elif impulse_vel.length() > bomb_push * bomb_mov_red_threshold:
		move_and_slide(velocity * bomb_mov_reduction + impulse_vel, Vector2.ZERO)
	else:
		move_and_slide(velocity + impulse_vel, Vector2.ZERO)

func _input(event):
	if event.is_action_pressed("bomb"):
		throw_bomb()

func get_input():
	input.x = Input.get_action_strength("mv_right") - Input.get_action_strength("mv_left")
	input.y = Input.get_action_strength("mv_down") - Input.get_action_strength("mv_up")
	input = input.normalized()

func apply_friction(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func apply_movement(delta):
	var movement = input * accel * delta
	velocity += movement
	velocity = velocity.clamped(max_speed)

func apply_impulse(impulse):
	impulse_vel += impulse

func throw_bomb():
	var b = Bullet.instance()
	b.start(global_position + Vector2(bomb_distance, 0).rotated(last_input.angle()), 
			last_input.angle(), bomb_speed + (velocity + impulse_vel).length(), bomb_push)
	get_parent().add_child(b)
