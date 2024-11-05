@tool
extends ShortcutButton
class_name OpenVirtualKeyboardButton

const SCENE: PackedScene = preload("virtual_keyboard.tscn")


func _ready() -> void:
	if not Engine.is_editor_hint():
		_update_visibility()
		InputMonitor.input_type_changed.connect(func(_input_type): _update_visibility())
		get_viewport().gui_focus_changed.connect(func(_focused: Control): _update_visibility())
		pressed.connect(_on_pressed)
	super._ready()


func _update_visibility() -> void:
	if not get_viewport():
		return

	var focused := get_viewport().gui_get_focus_owner()
	var should_be_visible := (
		InputMonitor.current_input_type == InputMonitor.InputType.JOYPAD and
		focused is LineEdit
	)
	visible = should_be_visible


func _on_pressed() -> void:
	var focused_control := get_viewport().gui_get_focus_owner()
	if focused_control is not LineEdit:
		printerr("Unsupported control for virtual keyboard: ", focused_control)
		return
	var line_edit := focused_control as LineEdit
	var _original_caret_force_displayed := line_edit.caret_force_displayed
	line_edit.caret_force_displayed = true
	var scene_instance := SceneStack.open_scene(SCENE, false) as VirtualKeyboard
	scene_instance.line_edit = line_edit
	scene_instance.tree_exiting.connect(func(): _on_keyboard_closing(line_edit, _original_caret_force_displayed))


func _on_keyboard_closing(line_edit: LineEdit, original_caret_force_displayed: bool) -> void:
	line_edit.grab_focus()
	var spin_box := line_edit.get_parent() as SpinBox
	if spin_box:
		spin_box.apply()
	line_edit.caret_force_displayed = original_caret_force_displayed
