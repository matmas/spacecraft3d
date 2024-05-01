@tool
extends BaseShape
class_name VisibleLinearVelocity

var _endpoint_2d: Vector2


static func is_enabled() -> bool:
	return ProjectSettings.get_setting(PROPERTY_PREFIX + "visible_linear_velocities")


static func register_settings() -> void:
	_register_setting(PROPERTY_PREFIX + "visible_linear_velocities", TYPE_BOOL, false)
	_register_setting(PROPERTY_PREFIX + "linear_velocity_color", TYPE_COLOR, Color.MAGENTA)
	_register_setting(PROPERTY_PREFIX + "linear_velocity_scale", TYPE_FLOAT, 1.0)


func _draw() -> void:
	draw_line(Vector2.ZERO, to_local(_endpoint_2d), ProjectSettings.get_setting(PROPERTY_PREFIX + "linear_velocity_color"))


func _process(delta: float) -> void:
	super._process(delta)

	var rigid_body := get_parent() as RigidBody3D

	var visual_node := rigid_body.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = rigid_body

	var camera := get_viewport().get_camera_3d()
	var scale_ := ProjectSettings.get_setting(PROPERTY_PREFIX + "linear_velocity_scale")
	_endpoint_2d = camera.unproject_position(visual_node.global_position + rigid_body.linear_velocity * scale_)
	queue_redraw()
