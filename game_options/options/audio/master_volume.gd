extends RangeOption

const MIN_DECIBELS = -60.0


func section() -> String:
	return "audio"


func key() -> String:
	return "master_volume"


func get_display_name() -> String:
	return tr("Master")


func get_display_category() -> String:
	return tr("Volume")


func set_value(value: Variant) -> void:
	var bus_index := AudioServer.get_bus_index(get_bus_name())
	AudioServer.set_bus_volume_db(bus_index, value)
	AudioServer.set_bus_mute(bus_index, value <= MIN_DECIBELS)
	value_changed.emit()


func get_value() -> Variant:
	var bus_index := AudioServer.get_bus_index(get_bus_name())
	return AudioServer.get_bus_volume_db(bus_index)


func get_min_value() -> float:
	return MIN_DECIBELS


func get_step() -> float:
	return 1.0 / 100.0 * -MIN_DECIBELS


func get_max_value() -> float:
	return 0.0


func get_display_value() -> String:
	match get_value():
		MIN_DECIBELS:
			return tr("Muted")
		var value:
			return "%d %%" % [(value - MIN_DECIBELS) / -MIN_DECIBELS * 100.0]


func get_bus_name() -> String:
	return "Master"
