extends KinematicBody2D

var push_force = 0
var velocity = Vector2()
var parent_id = 0
var detonated = false
var last_position


func start(pos, dir, speed, force, p_id):
	position = pos
	push_force = force
	parent_id = p_id
	velocity = Vector2(speed, 0).rotated(dir)
	self.rotation = velocity.angle()
	


func _physics_process(delta):
	if not detonated:
		var collision = move_and_collide(velocity * delta, true)
		if collision and collision.collider_id != parent_id:
			$ExplosionArea/CollisionShape2D.position = collision.position - position
			explode()


func _on_CharacterDetectionArea_area_entered(area):
	if not detonated and area.get_instance_id() != parent_id:
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
	$ExplossionParticles.emitting = true
	$AnimatedSprite.animation = "idle"
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", false)
	$ProjectileCollision.queue_free()
	$ExplosionDuration.start()


func _on_ExplosionDuration_timeout():
	$ExplosionArea.queue_free()
	$PickUpArea/CollisionShape2D.set_deferred("disabled", false)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
