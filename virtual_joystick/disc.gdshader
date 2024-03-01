shader_type canvas_item;
uniform vec4 color: source_color = vec4(vec3(1.0), 1.0);

float crossed_lines(vec2 uv) {
	vec2 center = vec2(0.5);
	float vertical_line = min(pow(1.0 - abs(center.x - uv.x), 40.0) * 4.0, 1.0);
	float horizontal_line = min(pow(1.0 - abs(center.y - uv.y), 40.0) * 4.0, 1.0);
	return vertical_line + horizontal_line;
}

float disc(vec2 uv) {
	vec2 center = vec2(0.5);
	return min(pow(1.0 - distance(center, uv), 18.0) * 1000.0, 1.0);
}

float inner_disc(vec2 uv) {
	vec2 center = vec2(0.5);
	return min(pow(1.0 - distance(center, uv), 40.0) * 10000.0, 1.0);
}

void fragment() {
	float pattern = clamp(disc(UV), 0.0, 1.0);
	COLOR = pattern * color;
}
