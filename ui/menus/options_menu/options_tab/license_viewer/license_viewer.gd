extends VBoxContainer


func set_license(license_name: String, license_text: String) -> void:
	%TitleLabel.text = license_name
	%Label.text = license_text
