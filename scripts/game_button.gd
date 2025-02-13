extends StaticBody2D

@export var door: Door
@export var hittable: Hittable

func _ready() -> void:
	if hittable:
		hittable.on_hit.connect(_on_hit)

func _on_hit() -> void:
	if door:
		door.open()
