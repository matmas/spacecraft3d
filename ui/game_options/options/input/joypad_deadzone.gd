extends RangeOption

enum Stick {
	LEFT,
	RIGHT
}
@export var stick := Stick.LEFT

@onready var current_value := 0.1


func key() -> String:
	return "joypad_deadzone_%s" % (Stick.find_key(stick) as String).to_snake_case()


func get_display_name() -> String:
	match stick:
		Stick.LEFT:
			return tr("Left stick")
		Stick.RIGHT:
			return tr("Right stick")
		_:
			return ""


func set_value(value: float) -> void:
	current_value = value
	_update_inputmap_deadzones()
	value_changed.emit()


func _ready() -> void:
	InputMonitor.input_map_changed.connect(_update_inputmap_deadzones)


func _update_inputmap_deadzones() -> void:
	for action in InputMap.get_actions():
		if action in ["ui_left", "ui_right", "ui_up", "ui_down"]:
			continue  # Joypad motions don't work well with these actions with deadzone values close to zero

		InputMap.action_set_deadzone(action, 0.5)  # Default of 0.5 is useful for JOY_AXIS_TRIGGER_(LEFT|RIGHT)
		for event in InputMap.action_get_events(action):
			if event is InputEventJoypadMotion:
				var joypad_motion := event as InputEventJoypadMotion
				match joypad_motion.axis:
					JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y when stick == Stick.LEFT:
						InputMap.action_set_deadzone(action, current_value)
						break
					JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y when stick == Stick.RIGHT:
						InputMap.action_set_deadzone(action, current_value)
						break


func get_value() -> float:
	return current_value


func get_min_value() -> float:
	return 0.0


func get_step() -> float:
	return 0.01


func get_max_value() -> float:
	return 1.0


func get_display_value() -> String:
	return "%s %%" % str(get_value() * 100.0)
