extends Node2D

@export var destructable_scene: PackedScene
@export var player: Node2D

func _ready():
	for i in range(3):  
		spawn_enemy(i)

func spawn_enemy(i):
	var enemy = destructable_scene.instantiate()
	
	var rand_x = randi_range(-200, 1000)
	var rand_y = randi_range(-200, 1000)
	enemy.global_position = Vector2(rand_x, rand_y)

	enemy.player = player
	
	add_child(enemy)
