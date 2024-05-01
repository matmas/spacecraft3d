@tool
extends BaseShape
class_name CenterOfMass


static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "show_centers_of_masses")


static func register_settings() -> void:
	_register_setting(PROPERTY_PREFIX + "show_centers_of_masses", TYPE_BOOL, false)
	_register_setting(PROPERTY_PREFIX + "center_of_mass_color", TYPE_COLOR, Color(0, 0.6, 0.7, 0.42))
	_register_setting(PROPERTY_PREFIX + "center_of_mass_outline_color", TYPE_COLOR, Color(0.5, 1, 1, 1))
	_register_setting(PROPERTY_PREFIX + "center_of_mass_circle_radius", TYPE_FLOAT, 3.0)


func _draw() -> void:
	var circle_radius := ProjectSettings.get_setting(PROPERTY_PREFIX + "center_of_mass_circle_radius")
	draw_circle(Vector2.ZERO, circle_radius, ProjectSettings.get_setting(PROPERTY_PREFIX + "center_of_mass_color"))
	draw_arc(Vector2.ZERO, circle_radius, 0, TAU, 16, ProjectSettings.get_setting(PROPERTY_PREFIX + "center_of_mass_outline_color"))


func get_global_position_3d() -> Vector3:
	var rigid_body := get_parent() as RigidBody3D
	return super.get_global_position_3d() + rigid_body.center_of_mass
