extends Area2D

class_name Destructable

@export var start_hp = 5
@export var hp = 5
@export var morrer = true
@onready var mat  = $ColorRect.material
signal morreu


func deal_damage(damage : int) -> void:
	hp -= damage
	var tween = create_tween()
	tween.tween_method(
		func(value): 
			mat.set_shader_parameter("hp_per", value),  
			mat.get_shader_parameter("hp_per"),
			float(hp)/float(start_hp),
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
		body.vida.collision_layer = 0
		body.vida.deal_damage(1)
		body.apply_knockback(global_position)
		
	
	

	
	
