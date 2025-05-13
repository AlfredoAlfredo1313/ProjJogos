class_name Lock_on_gun extends IGun
var detected_destructable : Array[Destructable] = []
var tween : Tween

func shoot():
	print("Shooot")

func _enter_tree() -> void:
	tween = create_tween()
	tween.tween_callback(func() : 
		if detected_destructable.size() <= 1:
			return
		detected_destructable.sort_custom(sort_by_distance)
	).set_delay(0.2)
	tween.set_loops(-1)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.is_in_group("Destructable"):
		return
	detected_destructable.append(area as Destructable)
	detected_destructable.sort_custom(sort_by_distance)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if !area.is_in_group("Destructable"):
		return
	detected_destructable.erase(area as Destructable)

func sort_by_distance(a : Node2D, b : Node2D):
	var a_distance = a.global_position.distance_squared_to(global_position)
	var b_distance = b;global_position.distance_squared_to(global_position)
	return a_distance < b_distance
	
func _draw() -> void:
	if detected_destructable.is_empty():
		return
	var player_pos = get_viewport_transform().translated_local(global_position).origin
	var target_pos = get_viewport_transform().translated_local(detected_destructable[0].global_position).origin
	print(detected_destructable[0].name)
	draw_line(player_pos, target_pos, Color.RED, 20, true)
	
	
	
