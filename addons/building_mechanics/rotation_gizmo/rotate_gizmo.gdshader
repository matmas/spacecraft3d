// 3D editor rotation manipulator gizmo shader.
// Taken from Godot souces in editor/plugins/node_3d_editor_plugin.cpp

shader_type spatial;

render_mode unshaded, depth_test_disabled, fog_disabled;

uniform vec4 albedo: source_color = vec4(1.0, 1.0, 1.0, 0.9);

mat3 orthonormalize(mat3 m) {
	vec3 x = normalize(m[0]);
	vec3 y = normalize(m[1] - x * dot(x, m[1]));
	vec3 z = m[2] - x * dot(x, m[2]);
	z = normalize(z - y * (dot(y, m[2])));
	return mat3(x,y,z);
}

void vertex() {
	mat3 mv = orthonormalize(mat3(MODELVIEW_MATRIX));
	vec3 n = mv * VERTEX;
	float orientation = dot(vec3(0.0, 0.0, -1.0), n);
	if (orientation <= 0.005) {
		VERTEX += NORMAL * 0.02;
	}

	VERTEX *= 0.2;

	// Fixed Size: Enabled
	if (PROJECTION_MATRIX[3][3] != 0.0) {
		// Orthogonal matrix; try to do about the same with viewport size.
		float h = abs(1.0 / (2.0 * PROJECTION_MATRIX[1][1]));
		// Consistent with vertical FOV (Keep Height).
		float sc = (h * 2.0);
		MODELVIEW_MATRIX[0] *= sc;
		MODELVIEW_MATRIX[1] *= sc;
		MODELVIEW_MATRIX[2] *= sc;
	} else {
		// Scale by depth.
		float sc = -(MODELVIEW_MATRIX)[3].z;
		MODELVIEW_MATRIX[0] *= sc;
		MODELVIEW_MATRIX[1] *= sc;
		MODELVIEW_MATRIX[2] *= sc;
	}
}

void fragment() {
	ALBEDO = albedo.rgb;
	ALPHA = albedo.a;
}
