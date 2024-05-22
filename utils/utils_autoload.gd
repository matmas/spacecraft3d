@tool
extends Node


func calculate_spatial_bounds(node: Node3D, include_top_level_transform: bool = false) -> AABB:
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


func raycast(parent_global_transform: Transform3D, relative_target: Vector3, collision_mask: int) -> Dictionary:
	return get_viewport().get_camera_3d().get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(
			parent_global_transform.origin,
			parent_global_transform.origin + parent_global_transform.basis * relative_target,
			collision_mask,
		)
	)


func unproject_aabb_to_screen_space_rect(aabb: AABB, transform: Transform3D, camera: Camera3D) -> Rect2:
	var vertex_positions := PackedVector2Array()
	vertex_positions.resize(8)
	for i in range(8):
		@warning_ignore("integer_division")
		var local_vertex := aabb.position + aabb.size * Vector3(i / 4, (i % 4) / 2, i % 2)
		var vertex := transform * local_vertex
		if camera.is_position_behind(vertex):
			return Rect2()
		vertex_positions[i] = camera.unproject_position(vertex)
	var rect := Rect2(vertex_positions[0], Vector2.ZERO)
	for i in range(1, 8):
		if not vertex_positions[i].is_zero_approx():
			rect = rect.expand(vertex_positions[i])
	var viewport_rect := camera.get_viewport().get_visible_rect()
	return rect if rect.intersects(viewport_rect) else Rect2()


func make_square(rect: Rect2, min_size: float = 0) -> Rect2:
	var center := rect.get_center()
	var square_size := maxf(maxf(rect.size.x, rect.size.y), min_size)
	return Rect2(
		center.x - square_size * 0.5,
		center.y - square_size * 0.5,
		square_size,
		square_size,
	)


func get_velocity(node: Node3D) -> Vector3:
	if node is RigidBody3D:
		return (node as RigidBody3D).linear_velocity
	return Vector3.ZERO


func print_0(what: Variant) -> void:
	if what is Transform3D:
		var t := what as Transform3D
		print(Transform3D(
			Vector3(_0(t.basis.x.x), _0(t.basis.x.y), _0(t.basis.x.z)),
			Vector3(_0(t.basis.y.x), _0(t.basis.y.y), _0(t.basis.y.z)),
			Vector3(_0(t.basis.z.x), _0(t.basis.z.y), _0(t.basis.z.z)),
			Vector3(_0(t.origin.x), _0(t.origin.y), _0(t.origin.z)),
		))
	elif what is Basis:
		var basis := what as Basis
		print(Basis(
			Vector3(_0(basis.x.x), _0(basis.x.y), _0(basis.x.z)),
			Vector3(_0(basis.y.x), _0(basis.y.y), _0(basis.y.z)),
			Vector3(_0(basis.z.x), _0(basis.z.y), _0(basis.z.z)),
		))
	else:
		print(what)


func _0(f: float) -> float:
	if is_zero_approx(f):
		return 0
	return f
