class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var max_speed := 200.0
@export var acceleration := 50.0
@export var deceleration := 0.2

@export_group("Gravity")
@export var up_gravity := 1.0
@export var down_gravity := 1.1
@export var release_force := 100.0

@export_group("Jump Settings")
@export var jump_velocity := 250.0
@export var buffer_time := 15.0
@export var coyote_time := 15.0

var jump_buffer_counter := 0.0
var coyote_counter := 0.0


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * up_gravity * delta
		else:
			velocity += get_gravity() * down_gravity * delta
			
	jump_action()
	movement()
	move_and_slide()


func movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x += direction * acceleration
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration)

	velocity.x = clampf(velocity.x, -max_speed, max_speed)


func jump_action() -> void:
	if is_on_floor() or is_on_ceiling():  # Check both floor and ceiling for a buffer
		coyote_counter = coyote_time
	else:
		if coyote_counter > 0:
			coyote_counter -= 1

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = buffer_time

	if Input.is_action_just_released("jump"):
		velocity.y += release_force * down_gravity

	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1

	if jump_buffer_counter > 0 and coyote_counter > 0:
		velocity.y = -jump_velocity
		jump_buffer_counter = 0
		coyote_counter = 0
