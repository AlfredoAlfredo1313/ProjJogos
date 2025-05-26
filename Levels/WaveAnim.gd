extends Label

func anim(_text : String):
	visible_characters = 0
	text = _text
	var vezes = _text.length()
	for i in range(vezes):
		visible_characters = i
		await get_tree().create_timer(0.4).timeout
	
