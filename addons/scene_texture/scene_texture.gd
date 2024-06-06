@tool
extends Texture2D
class_name SceneTexture

@export var size := Vector2i(256, 256)

@export var scene: PackedScene:
	set(value):
		scene = value
		emit_changed()
#
#@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,radians_as_degrees")  # TODO: Use this with Godot 4.3
@export var camera_rotation := Vector3(-TAU / 14.4, TAU / 12, 0):
	set(value):
		camera_rotation = value
		emit_changed()

@export_range(1, 179, 0.1, "degrees") var camera_fov := 40.0:
	set(value):
		camera_fov = value
		emit_changed()

#@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,radians_as_degrees")  # TODO: Use this with Godot 4.3
@export var directional_light_rotation := Vector3(-TAU / 20, TAU / 180, 0):
	set(value):
		directional_light_rotation = value
		emit_changed()

var _scene_tree_node: Node
var _sub_viewport: SubViewport
var _scene_root: Node3D
var _camera: Camera3D
var _directional_light: DirectionalLight3D


#region Texture2D virtual methods implementation

func _draw(to_canvas_item: RID, pos: Vector2, modulate: Color, transpose: bool) -> void:
	if _sub_viewport:
		_sub_viewport.get_texture().draw(to_canvas_item, pos, modulate, transpose)


func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool) -> void:
	if _sub_viewport:
		_sub_viewport.get_texture().draw_rect(to_canvas_item, rect, tile, modulate, transpose)


func _draw_rect_region(to_canvas_item: RID, rect: Rect2, src_rect: Rect2, modulate: Color, transpose: bool, clip_uv: bool) -> void:
	if _sub_viewport:
		_sub_viewport.get_texture().draw_rect_region(to_canvas_item, rect, src_rect, modulate, transpose, clip_uv)


func _get_width() -> int:
	return size.x


func _get_height() -> int:
	return size.y


func _has_alpha() -> bool:
	if _sub_viewport:
		return _sub_viewport.get_texture().has_alpha()
	return false


func _is_pixel_opaque(_x: int, _y: int) -> bool:
	return true
#endregion


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			if _scene_tree_node:
				_scene_tree_node.queue_free()


func _init() -> void:
	SceneTextures.ready.connect(_ready)
	changed.connect(_refresh)


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	if not SceneTextures.is_inside_tree():
		return

	if not _scene_tree_node:
		_scene_tree_node = Node.new()
		SceneTextures.add_child(_scene_tree_node)
		_sub_viewport = SubViewport.new()
		_sub_viewport.size = size
		_sub_viewport.own_world_3d = true
		_sub_viewport.transparent_bg = true
		_sub_viewport.msaa_3d = Viewport.MSAA_8X
		_sub_viewport.name = &"SubViewport"
		_scene_tree_node.add_child(_sub_viewport)

		_camera = Camera3D.new()
		_camera.name = &"Camera"
		_camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		_sub_viewport.add_child(_camera)

		_directional_light = DirectionalLight3D.new()
		_directional_light.name = &"DirectionalLight"
		_sub_viewport.add_child(_directional_light)

		_scene_root = Node3D.new()
		_scene_root.name = &"SceneRoot"
		_sub_viewport.add_child(_scene_root)

	SceneTextureUtils.remove_all_children(_scene_root)
	if scene:
		_scene_root.add_child(scene.instantiate())
	_update_camera_and_light()
	_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


func _update_camera_and_light() -> void:
	_camera.rotation = camera_rotation
	_camera.fov = camera_fov
	_update_camera_position()
	_directional_light.rotation = directional_light_rotation


func _update_camera_position() -> void:
	var aabb := SceneTextureUtils.calculate_spatial_bounds(_scene_root)
	var endpoints: Array[Vector3] = []
	for endpoint_idx in range(8):
		endpoints.push_back(aabb.get_endpoint(endpoint_idx))

	var planes := _camera.get_frustum().slice(2) as Array[Plane]  # [left, top, right, bottom]
	var new_planes: Array[Plane] = []
	for plane in planes:
		new_planes.push_back(Plane(plane.normal, endpoints.reduce(
			func(closest: Vector3, endpoint: Vector3):
				return endpoint if plane.distance_to(endpoint) > plane.distance_to(closest) else closest,
			endpoints[0]
		)))
	var horizontal_intersection := SceneTextureUtils.get_planes_intersection(new_planes[0], new_planes[2])
	var vertical_intersection := SceneTextureUtils.get_planes_intersection(new_planes[1], new_planes[3])

	if horizontal_intersection and vertical_intersection:
		var closest_points := SceneTextureUtils.closest_points_on_two_lines(
			horizontal_intersection[0], horizontal_intersection[1],
			vertical_intersection[0], vertical_intersection[1],
		)
		if closest_points:
			_camera.global_position = closest_points[0] if (closest_points[0] - closest_points[1]).dot(-_camera.basis.z) < 0.0 else closest_points[1]
