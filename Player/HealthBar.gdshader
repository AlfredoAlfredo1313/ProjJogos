shader_type canvas_item;
uniform float hp_per : hint_range(0.0, 1.0) = 1.0;
uniform vec3 green;
uniform vec3 red;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float alpha =  1.0;
	if (hp_per <= UV.x) {
		alpha = 0.0;
	}
	COLOR = vec4(mix(red, green, hp_per), alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
