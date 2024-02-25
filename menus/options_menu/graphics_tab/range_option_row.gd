extends HBoxContainer


func set_option(option: RangeOption) -> void:
	$Label.text = option.get_display_name()
	$HBoxContainer/HSlider.section = option.section()
	$HBoxContainer/HSlider.key = option.key()
	$HBoxContainer/ValueLabel.section = option.section()
	$HBoxContainer/ValueLabel.key = option.key()
	$GameOptionDescription.section = option.section()
	$GameOptionDescription.key = option.key()
