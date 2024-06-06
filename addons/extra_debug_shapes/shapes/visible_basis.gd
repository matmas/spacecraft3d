@tool
extends BaseDebugShape
class_name VisibleBasis

var _x_endpoint_2d: Vector2
var _y_endpoint_2d: Vector2
var _z_endpoint_2d: Vector2


static func is_node_supported(node: Node) -> bool:
	return node is CollisionObject3D


static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "visible_bases")


static func register_settings() -> void:
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "visible_bases", TYPE_BOOL, false)
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "basis_x_color", TYPE_COLOR, Color("#F63652"))
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "basis_y_color", TYPE_COLOR, Color("#8ED31C"))
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "basis_z_color", TYPE_COLOR, Color("#328FF2"))
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "basis_scale", TYPE_FLOAT, 1.0)


func _draw() -> void:
	if _x_endpoint_2d != Vector2.INF:
		draw_line(Vector2.ZERO, to_local(_x_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_x_color"))
	if _y_endpoint_2d != Vector2.INF:
		draw_line(Vector2.ZERO, to_local(_y_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_y_color"))
	if _z_endpoint_2d != Vector2.INF:
		draw_line(Vector2.ZERO, to_local(_z_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_z_color"))


func _process(delta: float) -> void:
	super._process(delta)

	var parent := get_parent() as CollisionObject3D

	var visual_node := parent.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = parent

	var scale_ := ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_scale") as float
	_x_endpoint_2d = ExtraDebugShapesUtils.unproject(visual_node.get_global_transform_interpolated().origin + visual_node.get_global_transform_interpolated().basis.x * scale_)
	_y_endpoint_2d = ExtraDebugShapesUtils.unproject(visual_node.get_global_transform_interpolated().origin + visual_node.get_global_transform_interpolated().basis.y * scale_)
	_z_endpoint_2d = ExtraDebugShapesUtils.unproject(visual_node.get_global_transform_interpolated().origin + visual_node.get_global_transform_interpolated().basis.z * scale_)
	queue_redraw()
