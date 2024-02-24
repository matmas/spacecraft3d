extends HBoxContainer


func set_option(option: Option) -> void:
	$Label.text = option.display_name()
	$GameOptionCheckButton.section = option.section()
	$GameOptionCheckButton.key = option.key()
