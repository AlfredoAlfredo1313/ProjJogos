extends CharacterBody2D
class_name Player
@export var speed := 300.0
@export var knockback_strength = 300
@export var knockback_duration = 0.2
@export var jump_speed := -1000.0
@export var gravity := 2500.0

@onready var sprite = $PlayerSprite
@onready var jump_sound = $JumpSound
@onready var basic_gun = $BasicGun as IGun
@onready var lock_gun = $LockOnGun as IGun
@onready var vida = $Vida

@export var bullet : PackedScene

var knockback_velocity = Vector2.ZERO
var knockback_timer = 0.0



func animate_side():
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	else:
		sprite.stop()
		
func get_side_input():
	velocity.x = 0
	var vel : Vector2
	vel.x = Input.get_axis("left", "right")
	vel.y = Input.get_axis("up", "down")
	velocity = vel.normalized() * speed
	
	if Input.is_action_just_pressed("click"):
		basic_gun.shoot()
		lock_gun.shoot()
		
		 

func move_side(): 
	move_and_slide()
	get_side_input()
	animate_side()

func print_position():
	print(position)

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func animate():
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.y > 0:
		sprite.play("down")
	elif velocity.y < 0:
		sprite.play("up")
	else:
		sprite.stop()
		
func move_8way(delta): 
	get_8way_input()
	animate()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)
	#move_and_slide()
	
func aim(delta):
	var dir_pointer = get_viewport().get_mouse_position()
	

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	aim(delta)
	if knockback_timer <= 0:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		knockback_timer -= delta
		velocity = knockback_velocity
	move_side()
	
	if vida.hp <= 0:
		print('morreuuuu')
		get_tree().change_scene_to_file("res://Levels/GameOver.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Levels/GameOver.tscn")
	pass # Replace with function body.
	
func apply_knockback(from_position: Vector2):
	var direction = (global_position - from_position).normalized()
	knockback_velocity = direction * knockback_strength
	knockback_timer = knockback_duration
	sprite.pisca_player()
