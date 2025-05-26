extends CenterContainer
@onready var label = $GameOver

func go_to_center(text):
	var tween = create_tween()
	label.text = text
	
