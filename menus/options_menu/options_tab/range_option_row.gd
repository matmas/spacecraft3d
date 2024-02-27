extends HBoxContainer


func set_option(option: RangeOption) -> void:
	$Label.text = option.get_display_name()
	$HSlider.option = option
	$DescriptionAndValue.option = option
