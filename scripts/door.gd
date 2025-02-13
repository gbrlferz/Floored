class_name Door
extends StaticBody2D

@export var auto := true

@onready var collider := $CollisionShape2D
@onready var sprite := $Sprite2D
@onready var player := %Player

var start_pos: Vector2
var closed := true

func _ready() -> void:
	start_pos = position

func _process(_delta: float) -> void:
	if auto:
		if start_pos.distance_to(player.position) < 32.0:
			open()
		else:
			close()

func open() -> void:
	if closed:
		position = start_pos - Vector2(0, 32)
		closed = false


func close() -> void:
	if !closed:
		position = start_pos
		closed = true
