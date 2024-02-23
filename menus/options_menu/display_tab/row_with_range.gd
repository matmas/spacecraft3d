extends HBoxContainer


func set_display_name(display_name: String) -> void:
	$Label.text = display_name


func set_section(section: String) -> void:
	$HBoxContainer/HSlider.section = section
	$HBoxContainer/SpinBox.section = section


func set_key(key: String) -> void:
	$HBoxContainer/HSlider.key = key
	$HBoxContainer/SpinBox.key = key
