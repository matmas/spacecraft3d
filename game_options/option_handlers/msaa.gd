extends OptionHandler

var DISABLED := tr("Disabled")
@onready var current_value = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d")


func section() -> String:
	return "display"


func key() -> String:
	return "msaa"


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_msaa_3d(get_viewport().get_viewport_rid(), value)
	current_value = value


func get_value() -> Variant:
	return current_value


func get_value_from_string(value: String) -> Variant:
	match value:
		DISABLED:
			return RenderingServer.VIEWPORT_MSAA_DISABLED
		"2x":
			return RenderingServer.VIEWPORT_MSAA_2X
		"4x":
			return RenderingServer.VIEWPORT_MSAA_4X
		"8x":
			return RenderingServer.VIEWPORT_MSAA_8X
		_:
			return null


func get_possible_string_values() -> Array[String]:
	return [DISABLED, "2x", "4x", "8x"]
