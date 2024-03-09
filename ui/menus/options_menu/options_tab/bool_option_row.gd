extends HBoxContainer


func set_option(option: BoolOption) -> void:
	$NameWithResetButton.set_option(option)
	$GameOptionCheckButton.option = option
	$GameOptionDescription.option = option
