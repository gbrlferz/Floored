class_name Hittable
extends Node

signal hit(damage: int)

func take_hit(damage: int) -> void:
	hit.emit(damage)
