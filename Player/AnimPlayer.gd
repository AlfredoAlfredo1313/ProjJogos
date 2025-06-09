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

@export var isInvincible:bool = false
@export var TIMER_CONST = 2.0
var timer:float = TIMER_CONST

var knockback_velocity = Vector2.ZERO
var knockback_timer = 0.0

func _ready() -> void:
	vida.recebeu_dano.connect(
		func(pos:Vector2):
			print("damageou")
			#vida.collision_layer = 0
			apply_knockback(pos)
	)
	
var last_dir_name := "down"  # Direção inicial padrão
func animate_side():
	var dir = velocity.normalized()

	# Jogador parado
	if dir == Vector2.ZERO:
		sprite.play("idle_" + last_dir_name)
		return

	# Jogador se movendo
	if dir.y < -0.5:
		if dir.x < -0.5:
			last_dir_name = "left_up"
		elif dir.x > 0.5:
			last_dir_name = "right_up"
		else:
			last_dir_name = "up"
	elif dir.y > 0.5:
		if dir.x < -0.5:
			last_dir_name = "left_down"
		elif dir.x > 0.5:
			last_dir_name = "right_down"
		else:
			last_dir_name = "down"
	else:
		if dir.x < 0:
			last_dir_name = "left_down"
		else:
			last_dir_name = "right_down"

	sprite.play(last_dir_name)
		
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

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
		
	
func aim(delta):
	var dir_pointer = get_viewport().get_mouse_position()
	

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	aim(delta)
	if knockback_timer <= 0:
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		knockback_timer -= delta
		velocity = knockback_velocity
	move_side()
	timerIvencibility(delta)
	
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
	isInvincible = true
	jump_sound.play()
	
	
func timerIvencibility(delta):
	if !isInvincible :
		return
	timer -= delta
	if timer<=0 :
		isInvincible = false
		timer = TIMER_CONST
			
