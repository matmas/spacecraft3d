extends OptionHandler

var ENABLED = tr("Enabled")
var DISABLED = tr("Disabled")
var ADAPTIVE = tr("Adaptive")
var MAILBOX = tr("Mailbox")


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


func get_possible_string_values() -> Array[String]:
	var possible_values: Array[String] = []
	var current = get_value()

	for value in [ENABLED, DISABLED, ADAPTIVE, MAILBOX]:
		if (value == MAILBOX and DisplayServer.get_name() == "X11"
				and RenderingServer.get_video_adapter_vendor() == "NVIDIA"
				and OS.get_video_adapter_driver_info()[0] == "nvidia"):
			# Prevents warning
			# "The requested V-Sync mode Mailbox is not available. Falling back to V-Sync mode Enabled."
			continue

		set_value_string(value)
		if value_string_matches(value):
			possible_values.push_back(value)

	set_value(current)
	return possible_values
