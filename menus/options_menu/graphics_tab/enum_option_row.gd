extends HBoxContainer


func set_option(option: EnumOption) -> void:
	$Label.text = option.get_display_name()
	$GameOptionButton.option = option
	$GameOptionDescription.option = option
