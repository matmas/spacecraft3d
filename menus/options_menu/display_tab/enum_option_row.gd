extends HBoxContainer


func set_option(option: EnumOption) -> void:
	$Label.text = option.get_display_name()
	$GameOptionButton.section = option.section()
	$GameOptionButton.key = option.key()
