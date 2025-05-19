class_name Lock_on_gun extends IGun
var detected_destructable : Array[Destructable] = []
var tween : Tween
@onready var line = $Line2D

func shoot():
	print("Shooot")

func _enter_tree() -> void:
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.default_color = Color.TRANSPARENT
	tween = create_tween()
	tween.tween_callback(func() : 
		if detected_destructable.size() <= 1:
			return
		detected_destructable.sort_custom(sort_by_distance)
	).set_delay(0.2)
	tween.set_loops(-1)
	
func _process(delta: float) -> void:
	draw()

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
	var b_distance = b.global_position.distance_squared_to(global_position)
	return a_distance < b_distance
	
func draw() -> void:
	if detected_destructable.is_empty():
		$Line2D.default_color = Color.TRANSPARENT
		return
	$Line2D.default_color = Color.RED
	var line_end = detected_destructable[0].global_position - global_position
	$Line2D.set_point_position(1, line_end)
	
	
	
