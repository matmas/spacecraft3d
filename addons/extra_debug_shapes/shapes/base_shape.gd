@tool
extends Node2D
class_name BaseShape

const PROPERTY_PREFIX = "debug/shapes/extra/"


static func _register_setting(property_name: String, type: int, default_value: Variant) -> void:
	if not ProjectSettings.has_setting(property_name):
		ProjectSettings.set(property_name, default_value)
		ProjectSettings.add_property_info({
			"name": property_name,
			"type": type,
		})
	ProjectSettings.set_initial_value(property_name, default_value)
	ProjectSettings.set_as_basic(property_name, true)


func get_global_position_3d() -> Vector3:
	var rigid_body := get_parent() as RigidBody3D

	var visual_node := rigid_body.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = rigid_body

	return visual_node.global_position


func _process(_delta: float) -> void:
	var global_position_3d := get_global_position_3d()

	var camera := get_viewport().get_camera_3d()
	visible = not camera.is_position_behind(global_position_3d)
	if visible:
		global_position = camera.unproject_position(global_position_3d)
