extends HBoxContainer


func set_option(option: InputActionOption) -> void:
	$NameWithResetButton.set_option(option)
	$KBMInputRemapButton.option = option
	$KBMInputRemapButton.is_controller_button = false
	$JoypadInputRemapButton.option = option
	$JoypadInputRemapButton.is_controller_button = true
