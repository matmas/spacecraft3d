@tool
extends BaseShape
class_name VisibleLinearVelocity

var _endpoint_2d: Vector2


static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "visible_linear_velocities")


static func register_settings() -> void:
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "visible_linear_velocities", TYPE_BOOL, false)
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "linear_velocity_color", TYPE_COLOR, Color.MAGENTA)
	ExtraDebugShapesUtils.register_setting(PROPERTY_PREFIX + "linear_velocity_scale", TYPE_FLOAT, 1.0)


func _draw() -> void:
	if _endpoint_2d != Vector2.INF:
		draw_line(Vector2.ZERO, to_local(_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "linear_velocity_color"))


func _process(delta: float) -> void:
	super._process(delta)

	var rigid_body := get_parent() as RigidBody3D

	var visual_node := rigid_body.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = rigid_body

	var scale_ := ProjectSettings.get_setting(PROPERTY_PREFIX + "linear_velocity_scale") as float
	_endpoint_2d = _unproject(visual_node.global_position + rigid_body.linear_velocity * scale_)
	queue_redraw()