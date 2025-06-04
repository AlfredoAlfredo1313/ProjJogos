extends Label

func anim(_text : String):
	print("chamoau")
	#visible_characters = 0
	text = _text
	var vezes = _text.length()
	#tween.tween_method(func(f):
	#	rotation = f	
	#, 0, PI, 0.5)
	#tween.set_loops(5)
	for i in range(vezes):
		print(_text.chr(i))
		if _text[i] == ' ':
			continue
		visible_characters = i
		await get_tree().create_timer(0.4).timeout
	visible_characters+=1
	await get_tree().create_timer(3).timeout
	for i in range(vezes):
		await get_tree().create_timer(0.4).timeout
		print(_text.chr(i))
		if _text[_text.length() - 1 - i] == ' ':
			visible_characters -= 2
			continue
		visible_characters -= 1
	visible_characters =0
	
