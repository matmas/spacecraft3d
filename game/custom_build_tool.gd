extends BuildTool


func _ready() -> void:
	super._ready()
	var camera := get_viewport().get_camera_3d()
	camera.add_child(raycast)


func is_input_place_block() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block")


func is_input_remove_block_pressed() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"remove_block")


func is_input_remove_block_released() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_released(&"remove_block")


func is_input_rotate_x_pos() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_x+")


func is_input_rotate_x_neg() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_x-")


func is_input_rotate_y_pos() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_y+")


func is_input_rotate_y_neg() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_y-")


func is_input_rotate_z_pos() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_z+")


func is_input_rotate_z_neg() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"rotate_z-")
