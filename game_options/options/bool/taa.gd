extends BoolOption

@onready var current_value := ProjectSettings.get_setting("rendering/anti_aliasing/quality/use_taa") as bool


func section() -> String:
	return "display"


func key() -> String:
	return "taa"


func get_display_name() -> String:
	return tr("TAA")


func get_display_category() -> String:
	return tr("Graphics")


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_use_taa(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value
