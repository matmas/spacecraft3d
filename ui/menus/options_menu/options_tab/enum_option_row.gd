extends HBoxContainer


func set_option(option: EnumOption) -> void:
	$NameWithResetButton.set_option(option)
	$GameOptionButton.option = option
	$GameOptionDescription.option = option
