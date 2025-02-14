extends CharacterBody2D

enum State {PATROL, CHASE}


@export var speed: float = 80.0
@export var gravity: float = 900.0
@export var patrol_points: Array[Marker2D]
@export var player_detection_radius: float = 150.0

@onready var sprite := $Sprite2D
@onready var player_detection := $PlayerDetection
@onready var patrol_timer := $PatrolTimer
@onready var edge_ray := $EdgeRay
@onready var wall_ray := $WallRay

var current_state: State = State.PATROL
var current_patrol_index: int = 0
var target_position: Vector2
var player: CharacterBody2D = null

func _ready() -> void:
	player_detection.body_entered.connect(_on_player_detection_body_entered)
	player_detection.body_exited.connect(_on_player_detection_body_entered)
	if patrol_points.size() > 0:
		target_position = patrol_points[current_patrol_index].global_position

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	match current_state:
		State.PATROL:
			patrol_state(delta)
		State.CHASE:
			chase_state(delta)
	
	move_and_slide()
	update_sprite_direction()
	print(global_position.distance_to(target_position))

func patrol_state(_delta: float) -> void:
	if patrol_points.size() == 0:
		return
	
	var direction: Vector2 = (target_position - global_position).normalized()
	velocity.x = direction.x * speed
	
	# Check if reached patrol point
	if global_position.distance_to(target_position) < 16.0:
		print("reached patrol point")
		current_patrol_index = wrapi(current_patrol_index + 1, 0, patrol_points.size())
		target_position = patrol_points[current_patrol_index].global_position
	
	# Check for obstacles
	if is_at_edge() or is_against_wall():
		reverse_patrol_direction()

func chase_state(_delta: float) -> void:
	if not player:
		return_to_patrol()
		return
	
	var direction: Vector2 = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	
	# Optional: Jump if player is above
	if player.global_position.y < global_position.y - 20.0 and is_on_floor():
		velocity.y = -300.0
	
	# Check if player is too far
	if global_position.distance_to(player.global_position) > player_detection_radius * 1.5:
		return_to_patrol()

func update_sprite_direction() -> void:
	if velocity.x != 0:
		sprite.scale.x = sign(velocity.x)

func is_at_edge() -> bool:
	return not edge_ray.is_colliding()

func is_against_wall() -> bool:
	return wall_ray.is_colliding()

func reverse_patrol_direction() -> void:
	current_patrol_index = wrapi(current_patrol_index - 1, 0, patrol_points.size())
	target_position = patrol_points[current_patrol_index].global_position

func return_to_patrol() -> void:
	current_state = State.PATROL
	if patrol_points.size() > 0:
		target_position = patrol_points[current_patrol_index].global_position

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		print(body)
		player = body
		current_state = State.CHASE
		patrol_timer.stop()

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		patrol_timer.start(2.0)  # Return to patrol after 2 seconds

func _on_patrol_timer_timeout() -> void:
	return_to_patrol()
