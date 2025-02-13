extends CharacterBody2D

# Projectile properties
@export var speed := 500.0
@export var damage := 10

var direction: Vector2 = Vector2.RIGHT  # Will be set by the weapon script

func _physics_process(_delta: float) -> void:
	# Move the projectile
	velocity = direction * speed

	move_and_slide()

	# Optional: Handle collisions
	if get_slide_collision_count() > 0:
		_on_collision()

func _on_collision() -> void:
	# Handle collision logic (e.g., damage, destroy projectile)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# If the collider has a HealthComponent, deal damage
		if collider.has_node("Hittable"):
			var hittable = collider.get_node("Hittable")
			hittable.hit()

	queue_free()
