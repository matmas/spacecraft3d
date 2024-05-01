@tool
extends Node2D
class_name CenterOfMass

const PROPERTY_PREFIX = "debug/shapes/extra/"

static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "show_centers_of_masses")


static func register_settings() -> void:
	_register_setting(PROPERTY_PREFIX + "show_centers_of_masses", TYPE_BOOL, false)
	_register_setting(PROPERTY_PREFIX + "center_of_mass_color", TYPE_COLOR, Color(0, 0.6, 0.7, 0.42))
	_register_setting(PROPERTY_PREFIX + "center_of_mass_outline_color", TYPE_COLOR, Color(0.5, 1, 1, 1))
	_register_setting(PROPERTY_PREFIX + "center_of_mass_circle_radius", TYPE_FLOAT, 3.0)


static func _register_setting(property_name: String, type: int, default_value: Variant) -> void:
	if not ProjectSettings.has_setting(property_name):
		ProjectSettings.set(property_name, default_value)
		ProjectSettings.add_property_info({
			"name": property_name,
			"type": type,
		})
	ProjectSettings.set_initial_value(property_name, default_value)
	ProjectSettings.set_as_basic(property_name, true)


func _draw() -> void:
	var circle_radius := ProjectSettings.get_setting(PROPERTY_PREFIX + "center_of_mass_circle_radius")
	draw_circle(Vector2.ZERO, circle_radius, ProjectSettings.get_setting(PROPERTY_PREFIX + "center_of_mass_color"))
	draw_arc(Vector2.ZERO, circle_radius, 0, TAU, 16, ProjectSettings.get_setting(PROPERTY_PREFIX + "center_of_mass_outline_color"))


func get_global_position_3d() -> Vector3:
	var rigid_body := get_parent() as RigidBody3D

	var visual_node := rigid_body.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = rigid_body

	return visual_node.global_position + rigid_body.center_of_mass


func _process(_delta: float) -> void:
	var global_position_3d := get_global_position_3d()

	var camera := get_viewport().get_camera_3d()
	visible = not camera.is_position_behind(global_position_3d)
	if visible:
		global_position = camera.unproject_position(global_position_3d)
