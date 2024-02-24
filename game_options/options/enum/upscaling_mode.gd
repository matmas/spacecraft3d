extends EnumOption

@onready var current_value = ProjectSettings.get_setting("rendering/scaling_3d/mode")

var BILINEAR = "Bilinear"
var FSR = "FSR 1.0"
var FSR2 = "FSR 2.2"


func section() -> String:
	return "display"


func key() -> String:
	return "upscaling_mode"


func get_display_name() -> String:
	return tr("Upscaling")


func get_display_category() -> String:
	return tr("Graphics")


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value


func get_value_from_string(value: String) -> Variant:
	match value:
		BILINEAR:
			return RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR
		FSR:
			return RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR
		FSR2:
			return RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2
		_:
			return null


func get_possible_string_values() -> Array[String]:
	return [BILINEAR, FSR, FSR2]
