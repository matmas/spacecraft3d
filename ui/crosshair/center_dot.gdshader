shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0);

float disc(vec2 uv) {
	vec2 center = vec2(0.5);
	return min(pow(1.0 - distance(center, uv), 20.0) * 2.0, 1.0);
}

void fragment() {
	float pattern = clamp(disc(UV), 0.0, 1.0);
	COLOR = pattern * color;
}
