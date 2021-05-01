extends Area2D

var push_force = 0
var velocity = Vector2()

func start(pos, dir, speed, force):
	position = pos
	rotation = dir
	push_force = force
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	position += velocity * delta

func _on_Bomb_body_shape_entered(body_id, body, body_shape, local_shape):
	if local_shape == 0:
		velocity = Vector2.ZERO
		$ExplosionCollision.set_deferred("disabled", false)
		$ProjectileCollision.set_deferred("disabled", true)
		
		$Timer.start()
		yield($Timer, "timeout")
		queue_free()
		
	elif local_shape == 1:
		if body.has_method("apply_impulse"):
			body.apply_impulse(global_position.direction_to(body.global_position) * push_force)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
