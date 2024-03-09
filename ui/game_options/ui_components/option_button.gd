extends OptionButton
class_name GameOptionButton

var option: Option

var _is_all_populated := false


func _init() -> void:
	item_selected.connect(_on_item_selected)
	button_down.connect(_on_button_down)


func _ready() -> void:
	_refresh()
	option.value_changed.connect(_refresh)


func _refresh() -> void:
	_is_all_populated = false
	var current_value = option.get_display_value()
	if current_value:
		clear()
		add_item(current_value)
		select(0)
	else:
		# get_display_value() is not implemented so populate everything
		_populate_all()
		_select_active()


func _on_button_down() -> void:
	if not _is_all_populated:
		_populate_all()
		_select_active()


func _populate_all() -> void:
	clear()
	for value in option.get_possible_display_values():
		add_item(value)
	_is_all_populated = true


func _on_item_selected(index: int) -> void:
	var value := get_item_text(index)
	option.set_display_value(value)
	GameOptions.save()


func _select_active() -> void:
	for index in item_count:
		var value := get_item_text(index)
		if option.display_value_matches(value):
			select(index)
