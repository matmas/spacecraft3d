extends HBoxContainer
class_name LicenseButtons


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
		var button := Button.new()
		button.text = get_license_name_for_display(license)
		add_child(button)

		button.pressed.connect(func(): _on_button_pressed(license))
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


func _on_button_pressed(license: String) -> void:
	var popup: Popup

	for child in get_children():
		if child is Popup:
			popup = child as Popup

	if not popup:
		popup = PopupPanel.new()
		popup.borderless = false
		popup.unresizable = false

		var scroll_container := JoypadScrollContainer.new()

		var label := Label.new()
		label.text = _license_info[license]
		scroll_container.add_child(label)

		popup.add_child(scroll_container)
		add_child(popup)

		var resize := func():
			var scrollbar_width_approx := 20 * get_window().content_scale_aspect
			popup.size = Vector2(
				minf(get_window().size.x, label.size.x + scrollbar_width_approx),
				minf(get_window().size.y, label.size.y + scrollbar_width_approx),
			)
			popup.move_to_center()
		resize.call()
		get_window().size_changed.connect(resize)
		popup.close_requested.connect(func(): popup.queue_free(); get_window().size_changed.disconnect(resize))

	popup.popup()