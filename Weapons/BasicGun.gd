class_name Basic_Gun extends IGun

@export var is_enemy = false
@export var bullet : PackedScene
@export var player_data : PlayerData
@onready var timer_tiro = $TimerTiro
var cool_down : bool = false

func shoot():
		if cool_down: 
			return
		if !is_enemy:
			timer_tiro.start(player_data.base_cadencia)
		else:
			timer_tiro.start(0.1)
		cool_down = true
		var b := bullet.instantiate()
		b.position = global_position
		owner.owner.add_child(b)
		var bullet = b as Bullet
		bullet.damage_layers = damage_layer
		bullet.set_rot(rotation)
		var pointer_vector = (get_global_mouse_position() - global_position).normalized()
		bullet.set_rot(pointer_vector.angle())

func enemy_shoot(target):
		var b := bullet.instantiate()
		b.position = global_position
		b.source = owner
		get_tree().current_scene.add_child(b)
		var bullet = b as Bullet
		bullet.damage_layers = damage_layer
		bullet.set_rot(rotation)
		var pointer_vector = (target - global_position).normalized()
		bullet.set_rot(pointer_vector.angle())
		bullet.set_bullet_color(Color(1, 0, 0))
		
func reset_cooldown():
	cool_down = false
	
