extends CanvasLayer

@export_flags_3d_physics var raycast_collision_mask := 0b00000000_00000000_00000000_11111111

const MIN_SIZE = 64

@onready var widget := $Widget as Control
@onready var label: Label = $Widget/Label


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS  # Update when changing content scale factor and game is paused


func _ready() -> void:
	widget.hide()


func _physics_process(_delta: float) -> void:
	if SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"select_object"):
		var camera := get_viewport().get_camera_3d()
		var viewport_center := get_viewport().get_visible_rect().size * 0.5
		var params := PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(get_viewport().get_mouse_position())
		params.to = params.from + camera.project_ray_normal(viewport_center) * camera.far
		params.collision_mask = raycast_collision_mask
		var result := camera.get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			if result.collider != ObjectSelection.selected_collider:
				ObjectSelection.selected_collider = result.collider
				ObjectSelectionUtils.fix_physics_interpolation(ObjectSelection.selected_collider)
		else:
			ObjectSelection.selected_collider = null


func _process(_delta: float) -> void:
	var selected_collider := ObjectSelection.selected_collider

	if not selected_collider:
		widget.hide()
		return

	var camera := get_viewport().get_camera_3d()
	widget.visible = not camera.is_position_behind(selected_collider.global_position)
	if widget.visible:
		var rect := Utils.unproject_aabb_to_screen_space_rect(Utils.calculate_spatial_bounds(selected_collider), selected_collider.get_global_transform_interpolated(), camera)
		if rect:
			rect = Utils.make_square(rect, MIN_SIZE)
			widget.position = rect.position
			widget.size = rect.size

			var distance := "%.0f m" % camera.global_position.distance_to(selected_collider.global_position)

			var camera_rigid_body := _get_camera_rigid_body_ancestor()
			var selected_collider_velocity := Utils.get_velocity(selected_collider)
			var relative_velocity := (
				camera.global_position.direction_to(selected_collider.global_position)
				.dot(selected_collider_velocity - camera_rigid_body.linear_velocity)
			)
			label.text = "%s\n%s\n%d m/s" % [selected_collider.name, distance, roundi(relative_velocity)]
		else:
			widget.visible = false


func _get_camera_rigid_body_ancestor() -> RigidBody3D:
	var parent := get_viewport().get_camera_3d().get_parent()
	while parent:
		if parent is RigidBody3D:
			return parent as RigidBody3D
		parent = parent.get_parent()
	return null
