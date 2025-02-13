class_name Hittable
extends Node

signal on_hit

func hit() -> void:
	print(get_parent().name + " hit!")
	on_hit.emit()
