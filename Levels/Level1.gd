extends Node2D

@export var enemy_shooter: PackedScene
@export var player: Node2D
@export var waves : Array[CardData] = []
var numero_inimigos
var wave_atual = 0

func _ready():
	start_wave()

func start_wave():
	var s = "Wave " + str(wave_atual)
	get_tree().call_group("HUD", "anim", s)
	if waves.size() <= wave_atual:
		print("venceu")
		return
	var wave = waves[wave_atual]
	numero_inimigos = wave.n_shooters + wave.n_simples
	var ss = "numero total " + str(numero_inimigos)
	print(ss)
	for i in range(wave.n_shooters):  
		spawn_enemy(enemy_shooter)
	for i in range(wave.n_simples):  
		spawn_enemy(enemy_shooter)
	
func spawn_enemy(enemy_type : PackedScene):
	var enemy = enemy_shooter.instantiate()
	var rand_x = randi_range(-200, 1000)
	var rand_y = randi_range(-200, 1000)
	enemy.global_position = Vector2(rand_x, rand_y)
	enemy.get_child(0).player = player
	(enemy as Destructable).morreu.connect(matou_inimigo)
	add_child(enemy)

func matou_inimigo():
	numero_inimigos -= 1
	if numero_inimigos <= 0:
		wave_atual += 1
		start_wave()
	
