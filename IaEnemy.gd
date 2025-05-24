extends Node2D
var player
@export var speed = 80.0
@export var orbit_radius: float = 100.0
var target_point: Vector2 = Vector2.ZERO

func _process(delta):
	if player:
		target_point = get_random_point_near_player(player.global_position, orbit_radius)
		if global_position.distance_to(target_point) < 10:
			target_point = get_random_point_near_player(player.global_position, orbit_radius)
		var direction = (target_point - global_position).normalized()
		get_parent().position += direction * speed * delta

func get_random_point_near_player(player_position: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * radius
	return player_position + offset
