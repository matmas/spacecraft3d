extends HBoxContainer


func set_option(option: Option) -> void:
	$Label.text = option.get_display_name()
	$GameOptionResetButton.option = option
