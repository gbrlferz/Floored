extends Sprite2D


@onready var player := $".."

func _process(_delta: float) -> void:
	if player.velocity.x > 0:
		flip_h = false
	elif player.velocity.x < 0:
		flip_h = true
