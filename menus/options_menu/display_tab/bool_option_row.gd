extends HBoxContainer


func set_option(option: BoolOption) -> void:
	$Label.text = option.get_display_name()
	$GameOptionCheckButton.section = option.section()
	$GameOptionCheckButton.key = option.key()
	$GameOptionDescription.section = option.section()
	$GameOptionDescription.key = option.key()
