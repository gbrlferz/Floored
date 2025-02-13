extends Node2D

@export var projectile_scene: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	var projectile = projectile_scene.instantiate()

	# Calculate direction to mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()

	projectile.global_position = global_position
	projectile.direction = direction

	# projectile.rotation = direction.angle()

	add_child(projectile)
