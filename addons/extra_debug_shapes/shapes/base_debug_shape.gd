@tool
extends Node2D
class_name BaseDebugShape

const PROPERTY_PREFIX = "debug/shapes/extra/"


static func is_node_supported(node: Node) -> bool:
	return true  # To be overridden in subclasses


func get_global_position_3d() -> Vector3:
	var parent := get_parent() as CollisionObject3D
	return parent.get_global_transform_interpolated().origin


func _process(_delta: float) -> void:
	global_position = ExtraDebugShapesUtils.unproject(get_global_position_3d())
	visible = global_position != Vector2.INF
