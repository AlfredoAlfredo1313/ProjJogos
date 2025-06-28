extends CharacterBody2D
class_name Player
@export var speed := 300.0
@export var knockback_strength = 300
@export var knockback_duration = 0.2
@export var jump_speed := -1000.0
@export var gravity := 2500.0
@export var player_data : PlayerData
@onready var sprite = $PlayerSprite
@onready var jump_sound = $JumpSound
@onready var basic_gun = $BasicGun as IGun
@onready var lock_gun = $LockOnGun as IGun
@onready var vida = $Vida
@export var bullet : PackedScene

@export var isInvincible:bool = false

var knockback_velocity = Vector2.ZERO

@onready var dodge_timer = $DodgeTimer
@onready var dodge_recovery_timer = $DodgeRecoveryTimer
@export var dodge_strengh = 600

var dodge_velocity = Vector2.ZERO
var mid_dodge = false
var dodge_recovery = false
var mid_knockback = false
var dodge_dir_name := ""

func _ready() -> void:
	vida.hp = player_data.base_hp
	vida.recebeu_dano.connect(
		func(pos:Vector2):
			#vida.collision_layer = 0
			apply_knockback(pos)
	)
	player_data.mod_velo.connect(func(new_vel):
		speed = new_vel
	)
	
var last_dir_name := "down"  # Direção inicial padrãoaaaa

func animate_side():
	if mid_dodge:
		sprite.play("dash_" + dodge_dir_name)
		return
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
	if Input.is_action_just_pressed("click"):
		basic_gun.shoot()
		lock_gun.shoot()

func move_side(): 
	move_and_slide()
	get_side_input()
	animate_side()
	
func aim(delta):
	var dir_pointer = get_viewport().get_mouse_position()

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	aim(delta)
	#Se não estiver em dodge ou em knockback
	if !mid_knockback and !mid_dodge:
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		input_vector = input_vector.normalized()
		#Se iniciar dodge
		if Input.is_action_just_pressed("dodge") and !dodge_recovery:
			apply_dodge(input_vector)
		#Se não ande normal
		else:
			velocity = input_vector * speed
	#Se em knockback
	elif !mid_dodge:
		velocity = knockback_velocity
	else:
	#Se em dodge
		velocity = dodge_velocity
	move_side()
	
	if vida.hp <= 0:
		get_tree().change_scene_to_file("res://Levels/GameOver.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Levels/GameOver.tscn")
	pass # Replace with function body.
	
func apply_knockback(from_position: Vector2):
	var direction = (global_position - from_position).normalized()
	knockback_velocity = direction * knockback_strength
	$KnBTimer.start()
	$InvTimer.start(player_data.base_kb_i)
	mid_knockback = true
	isInvincible = true
	sprite.pisca_player()
	jump_sound.play()
	#$KnBTimer.start()
	#$InvTimer.start()
	
func apply_dodge(direction: Vector2):
	mid_dodge = true
	dodge_recovery = true
	isInvincible = true
	dodge_velocity = direction * dodge_strengh
	velocity = dodge_velocity
	$InvTimer.start(player_data.base_dodge_i)
	$DodgeTimer.start()
	$DodgeRecoveryTimer.start()
	# Salva a direção para animação
	dodge_dir_name = get_direction_name(direction)
	sprite.play("dash_" + dodge_dir_name)
	print("dash_" + dodge_dir_name)
	
func get_direction_name(dir: Vector2) -> String:
	if dir == Vector2.ZERO:
		return last_dir_name

	if dir.y < -0.5:
		if dir.x < -0.5:
			return "left_up"
		elif dir.x > 0.5:
			return "right_up"
		else:
			return "up"
	elif dir.y > 0.5:
		if dir.x < -0.5:
			return "left_down"
		elif dir.x > 0.5:
			return "right_down"
		else:
			return "down" 
	else:
		if dir.x < 0:
			return "left_down"
		else:
			return "right_down"

func _reset_invincibility():
	isInvincible = false

func _on_dodge_timer_timeout() -> void:
	mid_dodge = false
	
func _on_dodge_recovery_timer_timeout() -> void:
	dodge_recovery = false
	
func _reset_knockback():
	mid_knockback = false
