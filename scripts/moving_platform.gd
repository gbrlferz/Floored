extends AnimatableBody2D

@onready var dest := $Destination
@onready var activation_area := $ActivationArea

var spawn_position: Vector2
var target_position: Vector2
var is_moving := false

func _ready() -> void:
	activation_area.body_entered.connect(_on_activation_body_entered)
	activation_area.body_exited.connect(_on_activation_body_exited)

	spawn_position = global_position
	target_position = dest.global_position


func _on_activation_body_entered(body: Node) -> void:
	if body is Player && !is_moving:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "global_position", target_position, 1.0)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)


func _on_activation_body_exited(body: Node) -> void:
	if body is Player && is_moving:
		is_moving = false
		if target_position == dest.position:
			target_position = spawn_position
		else:
			target_position = dest.position
