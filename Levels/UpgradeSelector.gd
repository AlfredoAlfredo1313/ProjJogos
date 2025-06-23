class_name UpgradeSelector extends Node

@onready var Button1 : UpButton = $Button
@onready var Button2 : UpButton = $Button2
@export var player_data : PlayerData

func assign_upgrades():
	var available_ups = player_data.get_available_upgrades()
	var rand_index = randi_range(0, available_ups.size() - 1)
	Button1.set_upgrade(available_ups[rand_index])
	available_ups.remove_at(rand_index)
	rand_index = randi_range(0, available_ups.size() - 1)
	Button2.set_upgrade(available_ups[rand_index])
	
