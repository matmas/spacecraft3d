extends HBoxContainer


func set_display_name(display_name: String) -> void:
	$Label.text = display_name


func set_section(section: String) -> void:
	$GameOptionButton.section = section


func set_key(key: String) -> void:
	$GameOptionButton.key = key
