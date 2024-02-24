extends HBoxContainer


func set_option(option: Option) -> void:
	$Label.text = option.display_name()
	$GameOptionButton.section = option.section()
	$GameOptionButton.key = option.key()
