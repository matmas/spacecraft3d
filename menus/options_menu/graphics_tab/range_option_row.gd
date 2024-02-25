extends HBoxContainer


func set_option(option: RangeOption) -> void:
	$Label.text = option.get_display_name()
	$HSlider.section = option.section()
	$HSlider.key = option.key()
	$DescriptionAndValue.section = option.section()
	$DescriptionAndValue.key = option.key()
