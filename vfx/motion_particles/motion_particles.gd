extends GPUParticles3D

@onready var particles_material := draw_pass_1.surface_get_material(0) as ShaderMaterial
var previous_camera_position: Vector3


func _ready() -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		previous_camera_position = camera.global_position


func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		global_transform = camera.global_transform

		var camera_velocity := (camera.global_position - previous_camera_position) / delta
		particles_material.set_shader_parameter(&"camera_velocity", camera_velocity)
		previous_camera_position = camera.global_position