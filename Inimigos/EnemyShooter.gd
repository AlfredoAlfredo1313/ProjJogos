extends Node2D
class_name EnemyShooter
var player
@export var speed = 80.0
@export var orbit_radius: float = 100.0
var target_point: Vector2 = Vector2.ZERO
var offset : Vector2

func _process(delta):
	var direction = (target_point - global_position).normalized()
	get_parent().position += direction * speed * delta

func get_random_point_near_player(player_position: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * radius
	return offset

func _on_timer_timeout() -> void:
	if ! player:
		return
	var pos = get_parent().position
	if pos.distance_to(player.global_position) >= pos.distance_to(player.global_position + offset):
		offset = get_random_point_near_player(player.global_position, orbit_radius)
	target_point = player.global_position + offset
	
