extends StaticBody2D

@export var only_once := true

@export_group("References")
@export var door: Door
@export var hittable: Hittable

func _ready() -> void:
	if hittable:
		hittable.hit.connect(_on_hit)


func _on_hit(_damage: int) -> void:
	if door:
		door.open()
	if only_once:
		queue_free()
