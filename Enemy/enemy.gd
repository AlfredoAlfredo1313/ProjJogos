extends CharacterBody2D

@export var speed: float = 100
var player_ref: CharacterBody2D = null

func _physics_process(delta):
	if player_ref == null:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player_ref = player
		return

	var direction = (player_ref.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
