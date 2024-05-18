@tool
extends Node2D
class_name BaseDebugShape

const PROPERTY_PREFIX = "debug/shapes/extra/"


static func is_node_supported(node: Node) -> bool:
	return true  # To be overridden in subclasses


func get_global_position_3d() -> Vector3:
	var collision_object := get_parent() as CollisionObject3D

	var visual_node := collision_object.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = collision_object

	return visual_node.global_position


func _process(_delta: float) -> void:
	global_position = _unproject(get_global_position_3d())
	visible = global_position != Vector2.INF


func _unproject(global_position_3d: Vector3) -> Vector2:
	var camera := get_viewport().get_camera_3d()
	if not camera.is_position_behind(global_position_3d):
		return camera.unproject_position(global_position_3d)
	else:
		return Vector2.INF
