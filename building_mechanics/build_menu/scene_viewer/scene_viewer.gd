@tool
extends Control
class_name SceneViewer

@export var scene: PackedScene:
	set(value):
		scene = value
		if is_inside_tree():
			_refresh()

@export var camera_rotation_degrees := Vector3(-25, 30, 0):
	set(value):
		camera_rotation_degrees = value
		if is_inside_tree():
			_refresh()

@export var camera_fov := 40.0:
	set(value):
		camera_fov = value
		if is_inside_tree():
			_refresh()

@export var directional_light_rotation_degrees := Vector3(-18, 2, 0):
	set(value):
		directional_light_rotation_degrees = value
		if is_inside_tree():
			_refresh()

@onready var sub_viewport := $SubViewport as SubViewport
@onready var scene_root := $SubViewport/SceneRoot as Node3D
@onready var camera := $SubViewport/Camera as Camera3D
@onready var directional_light := $SubViewport/DirectionalLight3D as DirectionalLight3D


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	Utils.remove_all_children(scene_root)
	if scene:
		var scene_instance := scene.instantiate()
		scene_root.add_child(scene_instance)
	_update_camera_and_light()
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


func _update_camera_and_light() -> void:
	camera.rotation_degrees = camera_rotation_degrees
	camera.fov = camera_fov
	directional_light.rotation_degrees = directional_light_rotation_degrees
	_update_camera_position()


func _update_camera_position() -> void:
	var aabb := Utils.calculate_spatial_bounds(scene_root)
	var endpoints: Array[Vector3] = []
	for endpoint_idx in range(8):
		endpoints.push_back(aabb.get_endpoint(endpoint_idx))

	var planes := camera.get_frustum().slice(2) as Array[Plane]  # [left, top, right, bottom]
	var new_planes: Array[Plane] = []
	for plane in planes:
		new_planes.push_back(Plane(plane.normal, endpoints.reduce(
			func(closest: Vector3, endpoint: Vector3):
				return endpoint if plane.distance_to(endpoint) > plane.distance_to(closest) else closest,
			endpoints[0]
		)))
	var horizontal_intersection := Utils.get_planes_intersection(new_planes[0], new_planes[2])
	var vertical_intersection := Utils.get_planes_intersection(new_planes[1], new_planes[3])

	if horizontal_intersection and vertical_intersection:
		var closest_points := Utils.closest_points_on_two_lines(
			horizontal_intersection[0], horizontal_intersection[1],
			vertical_intersection[0], vertical_intersection[1],
		)
		if closest_points:
			camera.global_position = closest_points[0] if (closest_points[0] - closest_points[1]).dot(-camera.basis.z) < 0.0 else closest_points[1]


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			camera.transform = Transform3D.IDENTITY
			camera.fov = 75
			directional_light.rotation = Vector3()
		NOTIFICATION_EDITOR_POST_SAVE:
			_update_camera_and_light()
