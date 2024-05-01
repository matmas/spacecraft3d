@tool
extends BaseShape
class_name VisibleBasis

var _x_endpoint_2d: Vector2
var _y_endpoint_2d: Vector2
var _z_endpoint_2d: Vector2


static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "visible_bases")


static func register_settings() -> void:
	_register_setting(PROPERTY_PREFIX + "visible_bases", TYPE_BOOL, false)
	_register_setting(PROPERTY_PREFIX + "basis_x_color", TYPE_COLOR, Color("#F63652"))
	_register_setting(PROPERTY_PREFIX + "basis_y_color", TYPE_COLOR, Color("#8ED31C"))
	_register_setting(PROPERTY_PREFIX + "basis_z_color", TYPE_COLOR, Color("#328FF2"))
	_register_setting(PROPERTY_PREFIX + "basis_scale", TYPE_FLOAT, 1.0)


func _draw() -> void:
	draw_line(Vector2.ZERO, to_local(_x_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_x_color"))
	draw_line(Vector2.ZERO, to_local(_y_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_y_color"))
	draw_line(Vector2.ZERO, to_local(_z_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_z_color"))


func _process(delta: float) -> void:
	super._process(delta)

	var rigid_body := get_parent() as RigidBody3D

	var visual_node := rigid_body.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = rigid_body

	var camera := get_viewport().get_camera_3d()
	var scale_ := ProjectSettings.get_setting(PROPERTY_PREFIX + "basis_scale")
	_x_endpoint_2d = camera.unproject_position(visual_node.global_position + visual_node.global_basis.x * scale_)
	_y_endpoint_2d = camera.unproject_position(visual_node.global_position + visual_node.global_basis.y * scale_)
	_z_endpoint_2d = camera.unproject_position(visual_node.global_position + visual_node.global_basis.z * scale_)
	queue_redraw()
