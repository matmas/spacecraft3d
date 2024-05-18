@tool
extends BaseDebugShape
class_name VisibleName


static func is_node_supported(node: Node) -> bool:
	return node is CollisionObject3D


static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "visible_names")


static func register_settings() -> void:
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "visible_names", TYPE_BOOL, false)


func _draw() -> void:
	draw_string(ThemeDB.fallback_font, Vector2.ZERO, get_parent().name, HORIZONTAL_ALIGNMENT_CENTER)
