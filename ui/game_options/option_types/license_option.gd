@icon("../icons/X509Certificate.svg")
extends Option
class_name LicenseOption

@export var software_name := ""
@export var source_url := ""
@export_multiline var copyright := ""
@export var license := ""


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


func get_license() -> String:
	return license


func _to_string() -> String:
	return "%s(%s)" % [get_software_name().to_pascal_case(), get_license()]
