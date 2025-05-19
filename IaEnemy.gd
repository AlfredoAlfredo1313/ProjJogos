extends Node2D
var player
@export var speed = 80.0

func _process(delta):
	if player:
		var direction = (player.global_position - get_parent().global_position).normalized()
		get_parent().position += direction * speed * delta
