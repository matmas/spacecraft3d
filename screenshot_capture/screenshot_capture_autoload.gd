extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"capture_screenshot") and OS.is_userfs_persistent():
		var image := get_viewport().get_texture().get_image()
		var timestamp := Time.get_datetime_string_from_system(true)
		var path := "user://screenshot-%s.png" % timestamp.validate_filename()
		image.save_png(path)
		var global_path := ProjectSettings.globalize_path(path)
		print("Screenshot saved to ", global_path)
