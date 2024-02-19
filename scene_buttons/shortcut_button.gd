extends InputActionButton
class_name ShortcutButton


func _ready() -> void:
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
	if property.name == "action_name" and shortcut:
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE
