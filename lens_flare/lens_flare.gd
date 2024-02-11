@tool
extends TextureRect
class_name LensFlare

@export var directional_light: DirectionalLight3D:
	set(value):
		directional_light = value
		update_configuration_warnings()
@export_flags_3d_physics var raycast_collision_mask = 0b11111111_11111111_11111111_11111111

@onready var shader_material := material as ShaderMaterial

var visibility := 0.0
var target_visibility := 0.0


func _ready() -> void:
	set_process(visible)
	set_physics_process(visible)


func get_light_apparent_global_position(camera: Camera3D) -> Vector3:
	return camera.global_position + directional_light.global_transform.basis.z * camera.far


func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if not camera or not directional_light or Engine.is_editor_hint():
		return
	visible = not camera.is_position_behind(get_light_apparent_global_position(camera))
	if visible:
		shader_material.set_shader_parameter(&"sun_position", camera.unproject_position(get_light_apparent_global_position(camera)))
		shader_material.set_shader_parameter(&"visibility", visibility)
		visibility = lerpf(visibility, target_visibility, 1 - pow(0.1, delta * 10.0))


func _physics_process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if not camera or not directional_light or Engine.is_editor_hint():
		return
	var space_state = camera.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.global_position
	params.to = get_light_apparent_global_position(camera)
	params.hit_back_faces = false
	params.collision_mask = raycast_collision_mask
	var result := space_state.intersect_ray(params)
	target_visibility = 0.0 if result else 1.0


func _get_configuration_warnings():
	if not directional_light:
		return ["Must have directional light assigned."]
	else:
		return []
