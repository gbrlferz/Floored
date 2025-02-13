class_name HealthComponent
extends Node

# Health properties
@export var max_health := 100
var current_health: int

func _ready() -> void:
	current_health = max_health


func take_damage(amount: int) -> void:
	current_health -= amount
	print("Took ", amount, " damage! Current health: ", current_health)

	if current_health <= 0:
		die()


func die() -> void:
	print("Health reached 0! Destroying object.")
	get_parent().queue_free()
