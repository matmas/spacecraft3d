extends BuildTool


func is_input_place_block() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block")


func is_input_remove_block_pressed() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_pressed(&"remove_block")


func is_input_remove_block_released() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_just_released(&"remove_block")


func is_input_rotate_block() -> bool:
	return SceneStack.current_scene() is Game and InputHints.is_action_pressed(&"rotate_block")


func add_physics_interpolation(node: Node3D) -> void:
	PhysicsInterpolation.apply(node)
