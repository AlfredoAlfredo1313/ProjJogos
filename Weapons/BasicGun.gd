class_name Basic_Gun extends IGun

@export var bullet : PackedScene

func shoot():
		var b := bullet.instantiate()
		b.position = global_position
		owner.owner.add_child(b)
		var bullet = b as Bullet
		bullet.set_rot(rotation)
		var pointer_vector = (get_global_mouse_position() - global_position).normalized()
		bullet.set_rot(pointer_vector.angle())

func enemy_shoot(target):
		var b := bullet.instantiate()
		b.position = global_position
		b.source = owner
		get_tree().current_scene.add_child(b)
		var bullet = b as Bullet
		bullet.set_rot(rotation)
		var pointer_vector = (target - global_position).normalized()
		bullet.set_rot(pointer_vector.angle())
	
	
