extends HBoxContainer


func set_option(option: InputActionOption) -> void:
	$Label.text = option.get_display_name()
	$KBMInputRemapButton.option = option
	$KBMInputRemapButton.is_controller_button = false
	$JoypadInputRemapButton.option = option
	$JoypadInputRemapButton.is_controller_button = true
