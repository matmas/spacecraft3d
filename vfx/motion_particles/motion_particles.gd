extends GPUParticles3D

@onready var particles_material := draw_pass_1.surface_get_material(0) as ShaderMaterial
var previous_camera_position: Vector3


func _physics_process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		if get_parent_node_3d() != camera:
			reparent(camera)

		var camera_velocity := (camera.global_position - previous_camera_position) / delta
		particles_material.set_shader_parameter(&"camera_velocity", camera_velocity)
		previous_camera_position = camera.global_position
