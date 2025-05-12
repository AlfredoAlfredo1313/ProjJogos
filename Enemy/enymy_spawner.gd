extends Node

@export var enemy_scene: PackedScene
@export var map_limits: Rect2 = Rect2(600, 400, 600, 400)  # ajuste ao tamanho do seu mapa

func _ready():
	spawn_enemy()

func spawn_enemy():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		var random_x = randi_range(map_limits.position.x, map_limits.position.x + map_limits.size.x)
		var random_y = randi_range(map_limits.position.y, map_limits.position.y + map_limits.size.y)
		enemy.global_position = Vector2(random_x, random_y)
		enemy.global_position = Vector2(random_x, random_y)
		get_tree().current_scene.add_child(enemy)
