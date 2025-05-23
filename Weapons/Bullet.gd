extends Area2D
class_name Bullet

@export var speed = 500 
var rot_angle : float
var set_ready = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("scale")
	
func set_rot(rot_angle : float) -> void:
	self.rot_angle = rot_angle
	set_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !set_ready:
		return
	global_position += Vector2(delta * speed, 0).rotated(rot_angle)
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Bullet saiu da Tela")
	queue_free()

func animation_finished() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Solid"):
		queue_free()
	elif area.is_in_group("Destructable"):
		var destruct_object = area as Destructable
		destruct_object.deal_damage(1)
		queue_free()
