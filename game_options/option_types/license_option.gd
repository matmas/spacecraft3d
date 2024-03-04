@icon("../icons/X509Certificate.svg")
extends Option
class_name LicenseOption

@export var software_name := ""
@export var source_url := ""
@export_multiline var copyright := ""
@export var license_name := ""


#region Mandatory Option functions
func key() -> String:
	return name.to_snake_case()


func get_value() -> Variant:
	return null


func set_value(_value: Variant) -> void:
	pass
#endregion


func get_software_name() -> String:
	return software_name


func get_copyright() -> String:
	return "\n".join(Array(copyright.split("\n")).map(func(c): return "© %s" % c))


func get_license_name() -> String:
	return license_name


#func _get_license_text(component: Dictionary) -> String:
	#var license_text := ""
#
	#var license_set := {}
	#for part in component["parts"]:
		#for licenses in Array(part["license"].split(" or ")).map(func(l): return l.split(" and ")):
			#for license in licenses:
				#license_set[license] = true
#
	##return ", ".join(license_set.keys())
	#for license in license_set.keys():
		#if license in _license_info:
			#license_text += _license_info[license]
		#else:
			#license_text += license
	#return license_text
