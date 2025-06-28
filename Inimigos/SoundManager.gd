extends Node

@onready var enemy_death := $EnemyDeathSoundPlayer
@onready var grave_destroy := $GraveDeathSoundPlayer

func play_enemy_death(tipo: String = "enemy"):
	match tipo:
		"grave":
			_tocar(grave_destroy)
		"enemy":
			_tocar(enemy_death)
		_:
			_tocar(enemy_death)  # fallback

func _tocar(player: AudioStreamPlayer):
	if player.playing:
		player.stop()
	player.play()
