extends Area2D
class_name Bullet

@export var speed = 500 
@export var player_data : PlayerData
var rot_angle : float
var set_ready = false
var damage_layers : Array[DamageLayers.damage_layers]
var source: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("scale")
	
func set_rot(rot_angle : float) -> void:
	self.rot_angle = rot_angle
	rotation = rot_angle  # ← gira visualmente a bala
	set_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !set_ready:
		return
	global_position += Vector2(delta * speed, 0).rotated(rot_angle)
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func animation_finished() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Solid"):
		queue_free()
	elif area.is_in_group("Destructable"):
		var destruct_object = area as Destructable
		var in_layer = false
		for layer in damage_layers:
			if layer in destruct_object.damage_layers:
				in_layer = true
				break
		if !in_layer:
			return
		if destruct_object.name == "Vida":
			if area.get_parent().isInvincible: return
		destruct_object.receive_damage(1, global_position)
		queue_free()

func set_bullet_color(color: Color) -> void:
	$BulletSprite.modulate = color
