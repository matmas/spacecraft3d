@tool
extends Control

@export var scene: PackedScene:
	set(value):
		scene = value
		_refresh()

@onready var sub_viewport: SubViewport = $SubViewport
@onready var scene_root = $SubViewport/SceneRoot
@onready var camera_3d := $SubViewport/Camera as Camera3D


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	if scene_root:
		Utils.remove_all_children(scene_root)
		if scene:
			var scene_instance := scene.instantiate()
			scene_root.add_child(scene_instance)
	if camera_3d:
		camera_3d.transform = _calculate_camera_transform()
	if sub_viewport:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


func _calculate_camera_transform() -> Transform3D:
	var aabb := Utils.calculate_spatial_bounds(scene_root)
	var bounding_sphere_radius := aabb.size.length() * 0.5
	var camera_distance := bounding_sphere_radius / sin(deg_to_rad(camera_3d.fov * 0.5))
	var transform := Transform3D.IDENTITY
	transform = transform.translated_local(aabb.get_center())
	transform = transform.rotated_local(Vector3.UP, PI / 6)
	transform = transform.rotated_local(Vector3.RIGHT, -PI / 7)
	transform = transform.translated_local(Vector3.BACK * camera_distance)

	#var rect := Rect2()
	#for index in range(8):
		#var endpoint := aabb.get_endpoint(index)
		#var point_2d := camera_3d.unproject_position(endpoint)
		#if index == 0:
			#rect.position = point_2d
		#else:
			#rect = rect.expand(point_2d)

	return transform


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			camera_3d.transform = Transform3D.IDENTITY
		NOTIFICATION_EDITOR_POST_SAVE:
			camera_3d.transform = _calculate_camera_transform()
