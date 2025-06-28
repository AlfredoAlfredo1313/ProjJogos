extends Node2D

@export var enemy_shooter: PackedScene
@export var enemy_walk: PackedScene
@export var player: Node2D
@export var waves : Array[CardData] = []
@export var tela_upgrade : Control
@onready var ysort_space = $YSortSpace
@onready var upgrade_sound = $UpgradeSound
var numero_inimigos
var wave_atual = 0

func _ready():
	tela_upgrade.visible = false
	start_wave()
	
func start_wave():
	var s = "Wave " + str(wave_atual)
	get_tree().call_group("HUD", "anim", s)
	if waves.size() <= wave_atual:
		return
	var wave = waves[wave_atual]
	numero_inimigos = wave.n_shooters + wave.n_simples
	var ss = "numero total " + str(numero_inimigos)
	for i in range(wave.n_shooters):  
		spawn_enemy(enemy_shooter)
	for i in range(wave.n_simples):  
		spawn_enemy(enemy_walk)
	
func spawn_enemy(tipo):
	var enemy = tipo.instantiate()
	var rand_x = randi_range(-200, 1000)
	var rand_y = randi_range(-200, 1000)
	enemy.global_position = Vector2(rand_x, rand_y)
	enemy.get_child(0).player = player
	(enemy as Destructable).morreu.connect(matou_inimigo)
	ysort_space.add_child(enemy)

func matou_inimigo():
	numero_inimigos -= 1
	if numero_inimigos <= 0:
		get_tree().paused = true
		tela_upgrade.assign_upgrades()
		tela_upgrade.visible = true
		upgrade_sound.play()
		
func proxima_wave():
	wave_atual += 1
	start_wave()
	
func _on_button_pressed() -> void:
	tela_upgrade.visible = false
	upgrade_sound.stop()
	get_tree().paused = false
	proxima_wave()
