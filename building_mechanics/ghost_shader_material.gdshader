shader_type spatial;
render_mode cull_disabled, blend_add, unshaded, shadows_disabled;

uniform vec3 color: source_color = vec3(1.0);

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void fragment() {
	float basic_fresnel = fresnel(3.0, NORMAL, VIEW);
	ALBEDO = color + basic_fresnel;
}
