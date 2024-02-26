extends EnumOption

@onready var last_current_screen := _get_current_screen()
@onready var last_screen_count := DisplayServer.get_screen_count()
@onready var last_primary_screen := DisplayServer.get_primary_screen()


func section() -> String:
	return "graphics"


func key() -> String:
	return "screen"


func get_display_name() -> String:
	return tr("Screen")


func get_display_category() -> String:
	return tr("Display")


func set_value(value: Variant) -> void:
	var window := get_window()
	var previous_mode := window.mode

	window.mode = Window.MODE_WINDOWED
	window.current_screen = value
	window.mode = previous_mode

	value_changed.emit()


func get_value() -> Variant:
	last_current_screen = _get_current_screen()
	return last_current_screen


func get_value_from_display_value(value: String) -> Variant:
	return int(value.split(" ")[1])


func get_possible_display_values() -> Array[String]:
	var possible_values: Array[String] = []

	for screen in DisplayServer.get_screen_count():
		possible_values.append(_get_display_value_from_value(screen))

	return possible_values


func get_display_value() -> String:
	return _get_display_value_from_value(get_value())


func _get_display_value_from_value(value: int) -> String:
	return tr("Screen %s" % value) + (tr(" (primary)") if value == DisplayServer.get_primary_screen() else "")


func _ready() -> void:
	var timer := Timer.new()
	add_child(timer)
	timer.start(0.1)
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	var current_screen := _get_current_screen()
	var screen_count := DisplayServer.get_screen_count()
	var primary_screen := DisplayServer.get_primary_screen()

	if (last_current_screen != current_screen
			or last_screen_count != screen_count
			or last_primary_screen != primary_screen):
		last_current_screen = current_screen
		last_screen_count = screen_count
		last_primary_screen = primary_screen
		value_changed.emit()


func _get_current_screen() -> int:
	# get_window().current_screen returns -1 on Android and 1 on web
	return mini(maxi(get_window().current_screen, 0), DisplayServer.get_screen_count() - 1)
