extends HBoxContainer


func set_display_name(display_name: String) -> void:
	$Label.text = display_name


func set_section(section: String) -> void:
	$GameOptionCheckButton.section = section


func set_key(key: String) -> void:
	$GameOptionCheckButton.key = key
