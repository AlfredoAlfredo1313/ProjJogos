extends Area2D

class_name Destructable

@export var start_hp = 5
@export var hp = 5
@onready var mat  = $ColorRect.material

func deal_damage(damage : int) -> void:
	hp -= damage
	var tween = create_tween()
	tween.tween_method(
	func(value): mat.set_shader_parameter("hp_per", value),  
	float(hp + damage)/float(start_hp),
	float(hp)/float(start_hp),
	0.5
  );
	if(hp <= 0):
		queue_free()
