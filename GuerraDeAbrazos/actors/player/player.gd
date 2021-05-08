extends KinematicBody2D

var player_id = 0
var device_id = 0

# Movement constants
export var max_speed = 200
export var accel = 1500
export var friction = 1500

# Movement variables
var velocity = Vector2.ZERO
var impulse_vel = Vector2.ZERO
var input = Vector2.ZERO
var last_input = Vector2.ZERO

# Bomb constants
export var bomb_speed = 200
export var bomb_push = 750
var Bullet = preload("res://actors/player/bomb.tscn")

# Controller asignment
func start(p_id, d_id, pos):
	player_id = p_id
	device_id = d_id
	position = pos


# Movement
func _physics_process(delta):
	get_input()

	if input == Vector2.ZERO:
		apply_friction(delta)
		change_animation("idle")
	else:
		apply_movement(delta)
		last_input = input
		change_animation("run")
	
	if impulse_vel == Vector2.ZERO:
		velocity = move_and_slide(velocity)
	else:
		var motion = velocity * (1 - impulse_vel.length()/bomb_push)
		move_and_slide(motion + impulse_vel)
		impulse_vel = impulse_vel.move_toward(Vector2.ZERO, friction * delta)


func _input(event):
	if event.is_action_pressed("bomb_" + str(device_id)):
		throw_bomb()


func get_input():
	var n = str(device_id)
	input.x = Input.get_action_strength("mv_right_" + n) - Input.get_action_strength("mv_left_" + n)
	input.y = Input.get_action_strength("mv_down_" + n) - Input.get_action_strength("mv_up_" + n)
	input = input.normalized()


func apply_friction(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func apply_movement(delta):
	var movement = input * accel * delta
	velocity += movement
	velocity = velocity.clamped(max_speed)


func apply_impulse(impulse):
	impulse_vel += impulse


func change_animation(animation):
	match animation:
		"idle":
			$AnimationTree.get("parameters/playback").travel("Idle")
		"run":
			$AnimationTree.set("parameters/Idle/blend_position", last_input)
			$AnimationTree.set("parameters/Run/blend_position", last_input)
			$AnimationTree.get("parameters/playback").travel("Run")


# Abilities
func throw_bomb():
	var b = Bullet.instance()
	b.start(global_position, 
			last_input.angle(), bomb_speed + (velocity + impulse_vel).length() * 0.5, bomb_push)
	get_parent().add_child(b)
