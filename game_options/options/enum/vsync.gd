extends EnumOption

var ENABLED := tr("Enabled")
var DISABLED := tr("Disabled")
var ADAPTIVE := tr("Adaptive")
var MAILBOX := tr("Mailbox")


func section() -> String:
	return "graphics"


func key() -> String:
	return "vsync"


func get_display_name() -> String:
	return tr("VSync")


func get_display_category() -> String:
	return tr("General")


func set_value(value: Variant) -> void:
	DisplayServer.window_set_vsync_mode(value)
	value_changed.emit()


func get_value() -> Variant:
	return DisplayServer.window_get_vsync_mode()


func get_value_from_display_value(value: String) -> Variant:
	match value:
		ENABLED:
			return DisplayServer.VSYNC_ENABLED
		DISABLED:
			return DisplayServer.VSYNC_DISABLED
		ADAPTIVE:
			return DisplayServer.VSYNC_ADAPTIVE
		MAILBOX:
			return DisplayServer.VSYNC_MAILBOX
		_:
			return null


func get_possible_display_values() -> Array[String]:
	var possible_values: Array[String] = []
	var current = get_value()
	for value in [ENABLED, DISABLED, ADAPTIVE, MAILBOX]:
		if (value == MAILBOX and DisplayServer.get_name() == "X11"
				and RenderingServer.get_video_adapter_vendor() == "NVIDIA"):
			# Assume OS.get_video_adapter_driver_info()[0] == "nvidia" as checking can take more than 100ms
			# Prevents warning
			# "The requested V-Sync mode Mailbox is not available. Falling back to V-Sync mode Enabled."
			continue

		DisplayServer.window_set_vsync_mode(get_value_from_display_value(value))  # Don't emit value_changed
		if display_value_matches(value):
			possible_values.push_back(value)

	DisplayServer.window_set_vsync_mode(current)  # Don't emit value_changed
	return possible_values


func get_display_value() -> String:
	match get_value():
		DisplayServer.VSYNC_ENABLED:
			return ENABLED
		DisplayServer.VSYNC_DISABLED:
			return DISABLED
		DisplayServer.VSYNC_ADAPTIVE:
			return ADAPTIVE
		DisplayServer.VSYNC_MAILBOX:
			return MAILBOX
		_:
			return ""
