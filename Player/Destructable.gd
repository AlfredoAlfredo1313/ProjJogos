extends Area2D

class_name Destructable

@export var start_hp = 5
@export var hp = 5
@export var morrer = true
@onready var mat  = $ColorRect.material
@export var TIMER_CONST = 2.0
@export var hasInvincible:bool 
var timer:float = TIMER_CONST
var isInvincible:bool = false

func deal_damage(damage : int) -> void:
	if isInvincible: return
	if hasInvincible: isInvincible = true
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
			queue_free()	
	)

		


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.vida.collision_layer = 0
		body.vida.deal_damage(1)
		body.apply_knockback(global_position)
		

func _process(delta: float) -> void:
	timerIvencibility(delta)
	
	
func timerIvencibility(delta):
	if !hasInvincible or !isInvincible :
		return
	timer -= delta
	if timer<=0 :
		isInvincible = false
		timer = TIMER_CONST
	collision_layer = 1	
	
	
