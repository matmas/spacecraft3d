extends HBoxContainer


func set_option(option: BoolOption) -> void:
	$Label.text = option.get_display_name()
	$GameOptionCheckButton.option = option
	$GameOptionDescription.option = option
