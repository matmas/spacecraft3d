extends HBoxContainer


func set_option(option: RangeOption) -> void:
	$NameWithResetButton.set_option(option)
	$HSlider.option = option
	$DescriptionAndValue.option = option
