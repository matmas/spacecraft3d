extends VBoxContainer


func set_option(option: LicenseOption) -> void:
	(%SoftwareName as Label).text = option.get_software_name()
	(%LicenseButtons as LicenseButtons).set_license(option.get_license())
	(%Copyright as Label).text = option.get_copyright()
