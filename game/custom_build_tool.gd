extends BuildTool


func _ready() -> void:
	super._ready()
	var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent()  # Need physics uninterpolated position
	camera_parent.add_child(raycast)


func is_input_place_block() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block")


func is_input_remove_block_pressed() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"remove_block")


func is_input_remove_block_released() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_released(&"remove_block")


func is_input_rotate_x_pos() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_x+")


func is_input_rotate_x_neg() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_x-")


func is_input_rotate_y_pos() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_y+")


func is_input_rotate_y_neg() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_y-")


func is_input_rotate_z_pos() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_z+")


func is_input_rotate_z_neg() -> bool:
	return SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_z-")


func add_physics_interpolation(node: Node3D) -> void:
	PhysicsInterpolation.apply(node)
