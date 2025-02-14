@tool
class_name HealthComponent
extends Node

@export var max_health := 100

var hittable: Hittable
var current_health: int

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	# Warn if not a child of Hittable
	if not get_parent() is Hittable:
		warnings.append("HealthComponent must be a child of Hittable node.")
	return warnings

func _ready() -> void:
	# Runtime validation (in case the warning is ignored)
	if not get_parent() is Hittable:
		push_error("HealthComponent must be a child of Hittable. Disabling.")
		set_process(false)
		return

	hittable = get_parent() as Hittable
	current_health = max_health
	hittable.hit.connect(_on_hit)


func _on_hit(damage: int) -> void:
	current_health -= damage

	if current_health <= 0:
		die()


func die() -> void:
	get_parent().get_parent().queue_free()
