extends AnimatedSprite2D
class_name Pisca_Player

func pisca_player():
	var vezes = 20
	for i in range(vezes):
		visible = not visible
		await get_tree().create_timer(0.1).timeout
	visible = true
