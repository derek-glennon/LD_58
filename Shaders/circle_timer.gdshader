shader_type canvas_item;

uniform float time_max = 1;
uniform float circle_size = 0.7;
uniform float current_time = 0;

float remap(float x, float old_min, float old_max, float new_min, float new_max)
{
	return new_min + (x - old_min) * (new_max - new_min) / (old_max - old_min);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 center_uvs = (UV - 0.5) * 2.0;
	float r = length(center_uvs.xy);
	float theta = atan(center_uvs.y, center_uvs.x);
	vec2 polar_uvs = vec2(r, theta);
	float step_value = remap(current_time, time_max, 0.01, -3.14, 3.14);
	theta = step(theta, step_value);
	
	float dist = 1.0 - distance(UV, vec2(0.5, 0.5));
	float circle = 1.0 - step(dist, circle_size);
	circle = circle * theta;
	COLOR = vec4(circle, circle, circle, circle);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
