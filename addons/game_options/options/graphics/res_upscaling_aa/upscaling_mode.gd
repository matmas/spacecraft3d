extends EnumOption

@onready var current_value = ProjectSettings.get_setting("rendering/scaling_3d/mode")

var BILINEAR = "Bilinear"
var FSR = "FSR 1.0"
var FSR2 = "FSR 2.2"


func key() -> String:
	return "upscaling_mode"


func get_display_name() -> String:
	return tr("Upscaling")


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_value_from_display_value(value: String) -> Variant:
	match value:
		BILINEAR:
			return RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR
		FSR:
			return RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR
		FSR2:
			return RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2
		_:
			return null


func get_possible_display_values() -> Array[String]:
	return [BILINEAR, FSR, FSR2]


func is_visible() -> bool:
	return ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method") not in ["mobile", "gl_compatibility"]
