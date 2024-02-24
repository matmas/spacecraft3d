extends HBoxContainer


func set_option(option: RangeOption) -> void:
	$Label.text = option.display_name()
	$HBoxContainer/HSlider.section = option.section()
	$HBoxContainer/HSlider.key = option.key()
	$HBoxContainer/SpinBox.section = option.section()
	$HBoxContainer/SpinBox.key = option.key()
	$HBoxContainer/SpinBox.suffix = option.spinbox_suffix()
