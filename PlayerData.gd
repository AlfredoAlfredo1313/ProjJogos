class_name PlayerData extends Resource

@export var hp : int = 5
@export var velocida : float = 300
@export var cadencia : float = 0.5
@export var dano : int = 1

signal mod_health(hp:int)
signal mod_velo(velo:float)
signal mod_cadence(cadence:float)
signal mod_dano(dano:int)

func reset_all():
	mod_health.emit(hp)
	mod_velo.emit(velocida)
	mod_cadence.emit(cadencia)
	mod_dano.emit(dano)
	
	
