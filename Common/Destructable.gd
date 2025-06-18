extends Area2D

class_name Destructable
@export var max_hp = 5
@export var hp = 5
@export var morrer = true
@export var damage_layers : Array[DamageLayers.damage_layers]
@onready var mat  = $ColorRect.material
@export var player_data : PlayerData
signal morreu
signal recebeu_dano

func _ready() -> void:
	if player_data:
		set_signal()

func set_signal():
	player_data.mod_health.connect(func(val):
		max_hp += val
		hp = max_hp	
		var tween = create_tween()
		tween.tween_method(
		func(value): 
			mat.set_shader_parameter("hp_per", value),  
			mat.get_shader_parameter("hp_per"),
			float(hp)/float(max_hp),0.5	);
	)
	
func receive_damage(damage : int, pos : Vector2) -> void:
	recebeu_dano.emit(pos)
	hp -= damage
	var tween = create_tween()
	tween.tween_method(
		func(value): 
			mat.set_shader_parameter("hp_per", value),  
			mat.get_shader_parameter("hp_per"),
			float(hp)/float(max_hp),
	0.5
	);
	tween.finished.connect(func(): 
		if(hp <= 0 && morrer):
			morreu.emit()
			queue_free()	
			get_tree().call_group("HUD", "update_score")
	)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player and !body.isInvincible:
		body.vida.receive_damage(1, global_position)
