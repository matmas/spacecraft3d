extends HBoxContainer
class_name LicenseButtons

@export var license_viewer_scene: PackedScene

static var _and_or_regex := RegEx.create_from_string("( and | or )(.*)")  # RegEx is greedy so we don't prefix it with (.*) to get the first part
static var _license_info := Engine.get_license_info()


func set_license(license: String) -> void:
	while true:
		var regex_match := _and_or_regex.search(license)
		if regex_match:
			add_ui_component(license.substr(0, len(license) - len(regex_match.strings[0])))  # Get the first part
#
			var label := Label.new()
			label.text = regex_match.strings[1]
			add_child(label)
#
			license = regex_match.strings[2]
		else:
			add_ui_component(license)
			break


func add_ui_component(license: String) -> void:
	if license in _license_info.keys():
		var button := OpenSceneButton.new()
		button.scene = license_viewer_scene
		button.text = get_license_name_for_display(license)
		add_child(button)

		button.scene_opened.connect(func(scene_instance): scene_instance.set_license(get_license_name_for_display(license), _license_info[license]))
	else:
		var label := Label.new()
		label.text = get_license_name_for_display(license)
		add_child(label)


func get_license_name_for_display(license: String) -> String:
	match license:
		"Expat":
			return "MIT"
		"public-domain":
			return "Public domain"
		_:
			return "%s" % license
