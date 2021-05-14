extends KinematicBody2D

var push_force = 0
var velocity = Vector2()
var parent_id = 0
var detonated = false


func start(pos, dir, speed, force, p_id):
	position = pos
	rotation = dir
	push_force = force
	parent_id = p_id
	velocity = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta):
	if not detonated:
		var collision = move_and_collide(velocity * delta, true)
		if collision and collision.collider_id != parent_id:
			explode()


func _on_PlayerDetection_body_entered(body):
	if body.get_instance_id() != parent_id:
		explode()


func _on_Explosion_body_entered(body):
	if body.has_method("apply_impulse"):
		body.apply_impulse(global_position.direction_to(body.global_position) * push_force)


func _on_PickUpArea_body_entered(body):
	if body.has_method("pick_bomb"):
		body.pick_bomb()
		queue_free()


func explode():
	detonated = true
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", false)
	$ProjectileCollision.set_deferred("disabled", true)
	$ExplosionDuration.start()


func _on_ExplosionDuration_timeout():
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", true)
	$PickUpArea/CollisionShape2D.set_deferred("disabled", false)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
