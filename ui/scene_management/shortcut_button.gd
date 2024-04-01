@tool
extends InputActionButton
class_name ShortcutButton
## Button that sets icon based on shortcut property automatically.
## Works with InputEventAction type events only.


func get_shortcut_action_name() -> StringName:
	return &""


func _ready() -> void:
	if get_shortcut_action_name() and not Engine.is_editor_hint():
		_ensure_shortcut_event(get_shortcut_action_name())

	if shortcut:
		action_name = _shortcut_to_action_name(shortcut)


func _set(property: StringName, value: Variant) -> bool:
	if property == "shortcut" and value:
		action_name = _shortcut_to_action_name(value as Shortcut)
	return false


func _shortcut_to_action_name(_shortcut: Shortcut) -> StringName:
	for event in _shortcut.events:
		if event is InputEventAction:
			return (event as InputEventAction).action
	return &""


func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if property.name == "action_name":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _ensure_shortcut_event(action: StringName) -> void:
	if not shortcut:
		shortcut = Shortcut.new()

	for event in shortcut.events:
		if event is InputEventAction:
			if (event as InputEventAction).action == action:
				return

	var event := InputEventAction.new()
	event.action = action
	shortcut.events.append(event)
