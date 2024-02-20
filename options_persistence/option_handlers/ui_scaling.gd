extends OptionHandler


func set_value(value: Variant) -> void:
	get_tree().root.content_scale_factor = value


func get_value() -> Variant:
	return get_tree().root.content_scale_factor


func get_value_from_string(value: String) -> Variant:
	return int(value.rstrip("%")) / 100.0
