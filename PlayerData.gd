class_name PlayerData extends Resource
enum Upgrades {Vida, Dano, Velocidade, Cadencia, Outro}

@export var base_hp : int = 5
@export var base_velocida : float = 300
@export var base_cadencia : float = 0.5
@export var base_dano : int = 1
@export var base_dodge_i : float = 0.4
@export var base_kb_i : float = 1

var up_disho = {"vida": Upgrades.Vida, "dano": Upgrades.Dano, "velo": Upgrades.Velocidade, "cadencia": Upgrades.Cadencia, "outro": Upgrades.Outro}
var available_ups = ["vida", "dano", "velo", "cadencia", "outro"]

var hp_upgrades = 1
var velocidade_upgrades = 1
var cadencia_upgrades = 1
var dano_upgrades = 1

var hp_up_max = 3
var velocidade_up_max = 3
var cadencia_up_max = 3
var dano_up_max = 3

signal mod_health(hp:int)
signal mod_velo(velo:float)
signal mod_cadence(cadence:float)
signal mod_dano(dano:int)

func send_upgrade(upgrade : Upgrades):
	match upgrade:
		Upgrades.Vida:
			hp_upgrades += 1
			if hp_upgrades >= hp_up_max:
				available_ups.erase("vida")
			mod_health.emit(hp_upgrades * base_hp)
		Upgrades.Cadencia:
			cadencia_upgrades +=1
			if cadencia_upgrades >= cadencia_up_max:
				available_ups.erase("cadencia")
			base_cadencia = max(0, base_cadencia - 0.15)
		Upgrades.Dano:
			dano_upgrades += 1
			if dano_upgrades >= dano_up_max:
				available_ups.erase("dano")
			base_dano += 1
		Upgrades.Velocidade:
			var new_vel = base_velocida * pow(1.20, velocidade_upgrades)
			velocidade_upgrades += 1
			if velocidade_upgrades >= velocidade_up_max:
				available_ups.erase("velo")
			mod_velo.emit(new_vel)
			

func reset_all():
	mod_health.emit(base_hp)
	mod_velo.emit(base_velocida)
	mod_cadence.emit(base_cadencia)
	mod_dano.emit(base_dano)
	
func get_available_upgrades() -> Array[int]:
	var av_ups :Array[int] = []
	for  k in available_ups:
		av_ups.append(up_disho[k])
	return av_ups
	
	
