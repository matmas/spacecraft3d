extends Node
class_name ExtraDebugShapesUtils


static func register_setting(property_name: String, type: int, default_value: Variant, hint: int = 0, hint_string: String = "") -> void:
	if not ProjectSettings.has_setting(property_name):
		ProjectSettings.set(property_name, default_value)
		ProjectSettings.add_property_info({
			"name": property_name,
			"type": type,
			"hint": hint,
			"hint_string": hint_string,
		})
	ProjectSettings.set_initial_value(property_name, default_value)
	ProjectSettings.set_as_basic(property_name, true)


static func unproject(global_position_3d: Vector3) -> Vector2:
	var camera := ExtraDebugShapes.get_viewport().get_camera_3d()
	if not camera.is_position_behind(global_position_3d):
		return camera.unproject_position(global_position_3d)
	else:
		return Vector2.INF
