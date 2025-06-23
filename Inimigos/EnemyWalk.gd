extends Node2D
class_name EnemyShooter
var player
@export var speed = 80.0
@export var orbit_radius: float = 100.0
@export var grave : PackedScene
var target_point: Vector2 = Vector2.ZERO
var offset : Vector2
var x:int = 0
@onready var basic_gun = $BasicGun as IGun
@onready var sprite = $AnimatedSprite2D

@onready var chapeu = $ChapeuAnimate
@onready var soft_collision = $SoftCollision
@export var soft_coll_strength = 200
var unaltered_direction : Vector2 

func _process(delta):
	var direction = (target_point - global_position).normalized()
	var animation_direction = (unaltered_direction - global_position).normalized()
	get_parent().position += direction * speed * delta
	# Animação
	if direction.length() > 0.1:  # Evita animação quando parado
		var dir_name = get_direction_name(direction)
		if sprite.animation != dir_name:
			sprite.play(dir_name)
		if chapeu.animation != dir_name:
			chapeu.play(dir_name)	
	else:
		sprite.stop()
		chapeu.stop()

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
	unaltered_direction = player.global_position + offset
	target_point = unaltered_direction + soft_collision.get_push_vector() * soft_coll_strength

func get_direction_name(direction: Vector2) -> String:
	if abs(direction.x) > abs(direction.y):
		return "right" if direction.x > 0 else "left"
	else:
		return "down" if direction.y > 0 else "up"
	
func setChapeu(x : bool):
	$ChapeuAnimate.visible = x
	
func create_grave():
	var grave_node : Node2D = grave.instantiate()
	grave_node.global_position = global_position
	get_parent().get_parent().add_child(grave_node)
	
