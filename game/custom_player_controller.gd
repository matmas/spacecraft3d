extends PlayerController


func get_input_look_direction() -> Vector2:
	return InputHints.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")


func get_input_move_direction() -> Vector2:
	return InputHints.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")


func is_input_move_left_released() -> bool:
	return InputHints.is_action_just_released(&"move_left")


func is_input_move_right_released() -> bool:
	return InputHints.is_action_just_released(&"move_right")


func is_input_move_forward_released() -> bool:
	return InputHints.is_action_just_released(&"move_forward")


func is_input_move_backward_released() -> bool:
	return InputHints.is_action_just_released(&"move_backward")


func is_input_jump() -> bool:
	return InputHints.is_action_pressed(&"jump")


func is_input_sprint() -> bool:
	return InputHints.is_action_pressed(&"sprint")


func is_input_crouch() -> bool:
	return InputHints.is_action_pressed(&"crouch")


func get_input_move_acceleration_direction() -> Vector3:
	return Vector3(
		InputHints.get_axis(&"move_left", &"move_right"),
		InputHints.get_axis(&"move_down", &"move_up"),
		InputHints.get_axis(&"move_forward", &"move_backward"),
	).normalized()


func get_input_roll_axis() -> float:
	return InputHints.get_axis(&"roll_left", &"roll_right")


func is_input_match_velocity() -> bool:
	return InputHints.is_action_pressed(&"match_velocity")


func get_selected_collider() -> Node3D:
	return ObjectSelection.selected_collider


func get_mouse_sensitivity() -> float:
	return GameOptions.get_range_option("input", "mouse_sensitivity").get_value()


func get_joypad_sensitivity() -> float:
	return GameOptions.get_range_option("input", "joypad_sensitivity").get_value()
