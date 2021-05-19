extends KinematicBody2D


const Bomb = preload("res://actors/player/bomb.tscn")

export var max_speed = 200
export var accel = 1500
export var friction = 1500
export var dash_speed = 600
export var dash_max_charges = 2
export var bomb_speed = 200
export var bomb_push = 750
export var bomb_charges = 2

var id = 0
var device_id = 0
var input = Vector2.ZERO
var last_input = Vector2.ZERO
var velocity = Vector2.ZERO
var impulse_vel = Vector2.ZERO
var dash_charges = dash_max_charges
var dashing = false


# Input
func _input(event):
	if event.is_action_pressed("bomb_" + str(device_id)):
		throw_bomb()
	elif event.is_action_pressed("dash_" + str(device_id)) and not dashing:
		dash()


func get_input():
	var n = str(device_id)
	input.x = Input.get_action_strength("mv_right_" + n) - Input.get_action_strength("mv_left_" + n)
	input.y = Input.get_action_strength("mv_down_" + n) - Input.get_action_strength("mv_up_" + n)
	input = input.normalized()


# Movement
func _physics_process(delta):
	get_input()
	
	if not dashing:
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
	if bomb_charges != 0:
		bomb_charges -= 1
		var b = Bomb.instance()
		b.start(global_position, 
				last_input.angle(), bomb_speed + (velocity + impulse_vel).length() * 0.5, bomb_push, get_instance_id())
		get_parent().add_child(b)


func pick_bomb():
	bomb_charges += 1


func dash():
	if dash_charges == dash_max_charges:
		$DashCD.start()
	
	if dash_charges > 0:
		dash_charges -= 1
		dashing = true
		velocity = Vector2(dash_speed, 0).rotated(last_input.angle())
		set_collision_mask_bit(2, false)
		$DashDuration.start()


func _on_DashDuration_timeout():
	$Tween.interpolate_property(self, "velocity", velocity, Vector2.ZERO, $DashDuration.wait_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()


func _on_DashCD_timeout():
	dash_charges += 1
	if dash_charges == dash_max_charges:
		$DashCD.stop()


func _on_Tween_tween_completed(object, key):
	if object == self and key == ":velocity":
		set_collision_mask_bit(2, true)
		dashing = false
