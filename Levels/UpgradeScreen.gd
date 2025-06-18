extends Button

@export var player_data : PlayerData

func btn1():
	player_data.mod_health.emit(10)


func _on_pressed() -> void:
	player_data.mod_health.emit(10)
