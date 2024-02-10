extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"capture_screenshot") and OS.is_userfs_persistent():
		var image := get_viewport().get_texture().get_image()
		var timestamp := Time.get_datetime_string_from_system(true)
		var path := "user://screenshots/screenshot-%s.png" % timestamp.validate_filename()
		var global_path := ProjectSettings.globalize_path(path)
		var directory := path.get_base_dir()
		var global_directory := ProjectSettings.globalize_path(path)
		var error := DirAccess.make_dir_recursive_absolute(directory)
		if error:
			printerr("Error while making directory %s: %s" % [global_directory, Utils.error_message(error)])
			return
		error = image.save_png(path)
		if error:
			printerr("Error while saving file %s: %s" % [global_path, Utils.error_message(error)])
			return
		print("Screenshot saved to ", global_path)
