extends Node
class_name ExtraDebugShapesUtils


static func get_shape_classes() -> Array[Script]:
	var result: Array[Script] = []

	for class_info in ProjectSettings.get_global_class_list():
		if class_info.base == &"BaseDebugShape":
			result.append(load(class_info.path))

	return result


static func register_setting(property_name: String, type: int, default_value: Variant) -> void:
	if not ProjectSettings.has_setting(property_name):
		ProjectSettings.set(property_name, default_value)
		ProjectSettings.add_property_info({
			"name": property_name,
			"type": type,
		})
	ProjectSettings.set_initial_value(property_name, default_value)
	ProjectSettings.set_as_basic(property_name, true)
