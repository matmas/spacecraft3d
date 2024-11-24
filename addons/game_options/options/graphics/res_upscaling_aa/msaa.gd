extends EnumOption

var DISABLED := tr("Disabled")
@onready var current_value = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d")


func key() -> String:
	return "msaa"


func get_display_name() -> String:
	return tr("MSAA")


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_msaa_3d(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_value_from_display_value(value: String) -> Variant:
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


func get_possible_display_values() -> Array[String]:
	return [DISABLED, "2x", "4x", "8x"]
