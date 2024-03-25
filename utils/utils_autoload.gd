@tool
extends Node


func get_or_add(dict: Dictionary, key: Variant, default: Variant) -> Variant:  # TODO: Use Dictionary.get_or_add() with Godot 4.3
	var result = dict.get(key)
	if not result:
		dict[key] = default
		return default
	return result


func remove_all_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()


func calculate_spatial_bounds(parent: Node3D, include_top_level_transform: bool = false) -> AABB:
	# Similar to Node3DEditorViewport::_calculate_spatial_bounds from Godot Engine
	var bounds: AABB

	var visual_instance := parent as VisualInstance3D
	if visual_instance:
		bounds = visual_instance.get_aabb()

	for child in parent.get_children():
		if child is Node3D:
			var child_bounds := calculate_spatial_bounds(child, true)

			if bounds.size == Vector3() and parent:
				bounds = child_bounds
			else:
				bounds.merge(child_bounds)

	if not bounds.size and not parent:
		bounds = AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4));

	if include_top_level_transform:
		bounds = parent.transform * bounds

	return bounds


func get_planes_intersection(p1: Plane, p2: Plane) -> PackedVector3Array:
	# https://stackoverflow.com/a/32410473
	var direction := p2.normal.cross(p1.normal)
	if direction.is_zero_approx():
		return []
	var origin := (direction.cross(p2.normal) * p1.d + p1.normal.cross(direction) * p2.d) / direction.length_squared()
	return [origin, direction]


func closest_points_on_two_lines(line1_origin: Vector3, line1_direction: Vector3, line2_origin: Vector3, line2_direction: Vector3) -> PackedVector3Array:
	# https://web.archive.org/web/20200629172501/http://wiki.unity3d.com/index.php/3d_Math_functions
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


func raycast(parent_global_transform: Transform3D, relative_target: Vector3, collision_mask: int) -> Dictionary:
	return get_viewport().get_camera_3d().get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(
			parent_global_transform.origin,
			parent_global_transform.origin + parent_global_transform.basis * relative_target,
			collision_mask,
		)
	)


func error_message(error: Error) -> String:
	match error:
		FAILED:
			return "Failed."
		ERR_UNAVAILABLE:
			return "Unavailable."
		ERR_UNCONFIGURED:
			return "Unconfigured."
		ERR_UNAUTHORIZED:
			return "Unauthorized."
		ERR_PARAMETER_RANGE_ERROR:
			return "Parameter range error."
		ERR_OUT_OF_MEMORY:
			return "Out of memory (OOM)."
		ERR_FILE_NOT_FOUND:
			return "File not found."
		ERR_FILE_BAD_DRIVE:
			return "Bad drive."
		ERR_FILE_BAD_PATH:
			return "Bad file path."
		ERR_FILE_NO_PERMISSION:
			return "No file permission."
		ERR_FILE_ALREADY_IN_USE:
			return "File already in use."
		ERR_FILE_CANT_OPEN:
			return "Can't open file."
		ERR_FILE_CANT_WRITE:
			return "Can't write to file."
		ERR_FILE_CANT_READ:
			return "Can't read file."
		ERR_FILE_UNRECOGNIZED:
			return "Unrecognized file."
		ERR_FILE_CORRUPT:
			return "File is corrupt."
		ERR_FILE_MISSING_DEPENDENCIES:
			return "Missing file dependencies."
		ERR_FILE_EOF:
			return "End of file (EOF)."
		ERR_CANT_OPEN:
			return "Can't open."
		ERR_CANT_CREATE:
			return "Can't create."
		ERR_QUERY_FAILED:
			return "Query failed."
		ERR_ALREADY_IN_USE:
			return "Already in use."
		ERR_LOCKED:
			return "Locked."
		ERR_TIMEOUT:
			return "Timeout."
		ERR_CANT_CONNECT:
			return "Can't connect."
		ERR_CANT_RESOLVE:
			return "Can't resolve."
		ERR_CONNECTION_ERROR:
			return "Connection error."
		ERR_CANT_ACQUIRE_RESOURCE:
			return "Can't acquire resource."
		ERR_CANT_FORK:
			return "Can't fork process."
		ERR_INVALID_DATA:
			return "Invalid data."
		ERR_INVALID_PARAMETER:
			return "Invalid parameter."
		ERR_ALREADY_EXISTS:
			return "Already exists."
		ERR_DOES_NOT_EXIST:
			return "Does not exist."
		ERR_DATABASE_CANT_READ:
			return "Database: Read error."
		ERR_DATABASE_CANT_WRITE:
			return "Database: Write error."
		ERR_COMPILATION_FAILED:
			return "Compilation failed."
		ERR_METHOD_NOT_FOUND:
			return "Method not found."
		ERR_LINK_FAILED:
			return "Linking failed."
		ERR_SCRIPT_FAILED:
			return "Script failed."
		ERR_CYCLIC_LINK:
			return "Cycling link (import cycle)."
		ERR_INVALID_DECLARATION:
			return "Invalid declaration."
		ERR_DUPLICATE_SYMBOL:
			return "Duplicate symbol."
		ERR_PARSE_ERROR:
			return "Parse error."
		ERR_BUSY:
			return "Busy."
		ERR_SKIP:
			return "Skip error."
		ERR_HELP:
			return "Help error. Used internally when passing --version or --help as executable options."
		ERR_BUG:
			return "Godot bug encountered."
		ERR_PRINTER_ON_FIRE:
			return "Printer is on fire."
		_:
			return "Unknown error."
