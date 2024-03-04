@icon("../icons/Godot.svg")
extends Option
class_name GodotLicenseBundle


#region Mandatory Option functions
func key() -> String:
	return name.to_snake_case()


func get_value() -> Variant:
	return null


func set_value(_value: Variant) -> void:
	pass
#endregion


func get_licenses() -> Array[LicenseOption]:
	var licenses: Array[LicenseOption] = []

	for component in Engine.get_copyright_info():
		var license := LicenseOption.new()
		license.software_name = component["name"]
		license.copyright = _get_copyright(component)
		license.license_name = _get_license_name(component)
		licenses.append(license)

	return licenses


func _get_license_name(component: Dictionary) -> String:
	var license_set := {}
	for part in component["parts"]:
		license_set[part["license"]] = true
	return ", ".join(license_set.keys())


func _get_copyright(component: Dictionary) -> String:
	var copyright_set := {}
	for part in component["parts"]:
		for copyright in part["copyright"]:
			copyright_set[copyright] = true
	var copyrights := copyright_set.keys()
	copyrights.sort_custom(func(a, b): return a > b)  # Descending order
	return "\n".join(copyrights)
