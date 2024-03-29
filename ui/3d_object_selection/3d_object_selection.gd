extends CanvasLayer

var raycast_collision_mask := 0b00000000_00000000_00000000_11111111
const MIN_SIZE = 64

@onready var widget := $Widget as Control
@onready var label: Label = $Widget/Label

var _selected_collider: Node3D  # Most likely CollisionObject3D (or VoxelLodTerrain)


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS  # Update when changing content scale factor and game is paused


func _ready() -> void:
	widget.hide()


func _physics_process(_delta: float) -> void:
	if InputHints.is_action_just_pressed(&"select_object"):
		var camera := get_viewport().get_camera_3d()
		var params := PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(get_viewport().get_mouse_position())
		params.to = params.from + camera.project_ray_normal(get_viewport().get_mouse_position()) * camera.far
		params.collision_mask = raycast_collision_mask
		var result := camera.get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			if result.collider != _selected_collider:
				_selected_collider = result.collider
		else:
			_selected_collider = null


func _process(_delta: float) -> void:
	if not _selected_collider:
		widget.hide()
		return

	var camera := get_viewport().get_camera_3d()

	var selected_visual_node := _selected_collider.get_node_or_null("PhysicsInterpolation") as Node3D
	if not selected_visual_node:
		selected_visual_node = _selected_collider

	widget.visible = not camera.is_position_behind(_selected_collider.global_position)
	if widget.visible:
		var rect := Utils.unproject_aabb_to_screen_space_rect(Utils.calculate_spatial_bounds(_selected_collider), selected_visual_node.global_transform, camera)
		if rect:
			rect = Utils.make_square(rect, MIN_SIZE)
			widget.position = rect.position
			widget.size = rect.size

			var distance := "%.0f m" % camera.global_position.distance_to(_selected_collider.global_position)
			var velocity := ""
			var camera_rigid_body := _get_camera_rigid_body_ancestor()
			if camera_rigid_body:
				var selected_collider_velocity := Vector3()
				if _selected_collider is RigidBody3D:
					selected_collider_velocity = (_selected_collider as RigidBody3D).linear_velocity
				var relative_velocity := roundi(camera.global_position.direction_to(_selected_collider.global_position).dot(selected_collider_velocity - camera_rigid_body.linear_velocity))
				velocity = "%d m/s" % relative_velocity
			label.text = "%s\n%s\n%s" % [_selected_collider.name, distance, velocity]
		else:
			widget.visible = false


func _get_camera_rigid_body_ancestor() -> RigidBody3D:
	var parent := get_viewport().get_camera_3d().get_parent()
	while parent:
		if parent is RigidBody3D:
			return parent as RigidBody3D
		parent = parent.get_parent()
	return null
