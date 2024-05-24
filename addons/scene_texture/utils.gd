extends Node
class_name SceneTextureUtils


static func remove_all_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()


static func calculate_spatial_bounds(node: Node3D, include_top_level_transform: bool = false) -> AABB:
	# Similar to Node3DEditorViewport::_calculate_spatial_bounds from Godot Engine
	var bounds: AABB

	var visual_instance := node as VisualInstance3D
	if visual_instance:
		bounds = visual_instance.get_aabb()

	for child in node.get_children():
		if child is Node3D:
			var child_bounds := calculate_spatial_bounds(child, not child.top_level)

			if bounds.size == Vector3() and node:
				bounds = child_bounds
			else:
				bounds = bounds.merge(child_bounds)

	if not bounds.size and not node:
		bounds = AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4));

	if include_top_level_transform:
		bounds = node.transform * bounds

	return bounds


static func get_planes_intersection(p1: Plane, p2: Plane) -> PackedVector3Array:
	# https://stackoverflow.com/a/32410473
	var direction := p2.normal.cross(p1.normal)
	if direction.is_zero_approx():
		return []
	var origin := (direction.cross(p2.normal) * p1.d + p1.normal.cross(direction) * p2.d) / direction.length_squared()
	return [origin, direction]


static func closest_points_on_two_lines(line1_origin: Vector3, line1_direction: Vector3, line2_origin: Vector3, line2_direction: Vector3) -> PackedVector3Array:
	# https://web.archive.org/web/20200629172501/http://wiki.unity3d.com/index.php/3d_Math_functions
	# Alternative: https://stackoverflow.com/a/10554546/682025
	var a := line1_direction.dot(line1_direction)
	var b := line1_direction.dot(line2_direction)
	var e := line2_direction.dot(line2_direction)
	var d := a * e - b * b

	if is_zero_approx(d):
		return []  # Lines are parallel

	var origin_diff := line1_origin - line2_origin
	var c := line1_direction.dot(origin_diff)
	var f := line2_direction.dot(origin_diff)
	var closest_point_on_line1 := line1_origin + line1_direction * (b * f - e * c) / d
	var closest_point_on_line2 := line2_origin + line2_direction * (a * f - b * c) / d
	return [closest_point_on_line1, closest_point_on_line2]
