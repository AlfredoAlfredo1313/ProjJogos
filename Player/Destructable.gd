extends Area2D

class_name Destructable

@export var start_hp = 5
@export var hp = 5
@onready var mat  = $ColorRect.material
@export var speed = 80.0
@onready var player = null

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
		if(hp <= 0):
			queue_free()	
	)
func _process(delta):
	if not player:
		player = get_tree().get_root().get_node("Player/AnimPlayer")
		if not player:
			return
	var direction = (player.global_position - global_position).normalized()
	position += direction * speed * delta
