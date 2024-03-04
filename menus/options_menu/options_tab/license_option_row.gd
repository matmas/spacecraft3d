extends VBoxContainer


func set_option(option: LicenseOption) -> void:
	%SoftwareName.text = option.get_software_name()
	%LicenseName.text = option.get_license_name()
	%Copyright.text = option.get_copyright()
