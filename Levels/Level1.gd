extends Node2D

@export var destructable_scene: PackedScene
@export var player: Node2D
@export var lista_inimigos : Array[int] = [] 
@onready var wave_text = $CenterContainer
var numero_inimigos
var wave_atual = 0

func _ready():
	start_wave()

func start_wave():
	if lista_inimigos.size() <= wave_atual:
		print("venceu")
		return
	print("wave ", wave_atual)
	numero_inimigos = lista_inimigos[wave_atual]
	for i in range(numero_inimigos):  
		spawn_enemy()

func spawn_enemy():
	var enemy = destructable_scene.instantiate()
	lista_inimigos.append(enemy)
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
	
