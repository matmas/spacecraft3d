@tool
extends Node2D
class_name CenterOfMass

const CIRCLE_RADIUS = 3.0


func _draw() -> void:
	draw_circle(Vector2.ZERO, CIRCLE_RADIUS, ProjectSettings.get_setting("debug/shapes/collision/shape_color"))
	draw_arc(Vector2.ZERO, CIRCLE_RADIUS, 0, TAU, 16, ProjectSettings.get_setting("debug/shapes/navigation/geometry_edge_color"))


func get_global_position_3d() -> Vector3:
	var rigid_body := get_parent() as RigidBody3D

	var visual_node := rigid_body.get_node_or_null("PhysicsInterpolation") as Node3D
	if not visual_node:
		visual_node = rigid_body

	return visual_node.global_position + rigid_body.center_of_mass


func _process(_delta: float) -> void:
	var global_position_3d := get_global_position_3d()

	var camera := get_viewport().get_camera_3d()
	visible = not camera.is_position_behind(global_position_3d)
	if visible:
		global_position = camera.unproject_position(global_position_3d)
