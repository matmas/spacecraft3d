extends OptionHandler


func section() -> String:
	return "display"


func key() -> String:
	return "vsync"


func set_value(value: Variant) -> void:
	DisplayServer.window_set_vsync_mode(value)


func get_value() -> Variant:
	return DisplayServer.window_get_vsync_mode()


func get_value_from_string(value: String) -> Variant:
	match value:
		"Enabled":
			return DisplayServer.VSYNC_ENABLED
		"Disabled":
			return DisplayServer.VSYNC_DISABLED
		"Adaptive":
			return DisplayServer.VSYNC_ADAPTIVE
		"Mailbox":
			return DisplayServer.VSYNC_MAILBOX
		_:
			return null
