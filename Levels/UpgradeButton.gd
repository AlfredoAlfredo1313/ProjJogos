class_name UpButton
extends Button

@export var player_data : PlayerData
@export var upgrade : PlayerData.Upgrades
#enum Upgrades {Vida, Dano, Velocidade, Cadencia, Outro}
var up_labels = ["Vida", "Dano", "Velocidade", "Cadencia", "???"]

func _on_pressed() -> void:
	player_data.send_upgrade(upgrade)

func set_upgrade(up):
	print(up)
	upgrade = up
	text = up_labels[up]
	
func _on_button_mouse_entered() -> void:
	if Input.is_action_pressed("down"):
		set_upgrade(0)
		return
	elif Input.is_action_pressed("right"):
		set_upgrade(1)
		return
	elif Input.is_action_pressed("up"):
		set_upgrade(2)
		return
	elif Input.is_action_pressed("left"):
		set_upgrade(3)
		return
