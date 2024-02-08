extends "res://addons/controller_icons/Mapper.gd"

func _convert_joypad_to_steam(path: String):
	path = path.replace("joypad", "steam")
	match path.substr(path.find("/") + 1):
		"r_stick_click":
			return path.replace("/r_stick_click", "/right_track_center")
		"select":
			return path.replace("/select", "/back")
		"home":
			return path.replace("/home", "/system")
		"dpad":
			return path.replace("/dpad", "/left_track")
		"dpad_up":
			return path.replace("/dpad_up", "/left_track_up")
		"dpad_down":
			return path.replace("/dpad_down", "/left_track_down")
		"dpad_left":
			return path.replace("/dpad_left", "/left_track_left")
		"dpad_right":
			return path.replace("/dpad_right", "/left_track_right")
		"l_stick":
			return path.replace("/l_stick", "/stick")
		"l_stick_up":
			return path.replace("/l_stick_up", "/stick_up")
		"l_stick_down":
			return path.replace("/l_stick_down", "/stick_down")
		"l_stick_left":
			return path.replace("/l_stick_left", "/stick_left")
		"l_stick_right":
			return path.replace("/l_stick_right", "/stick_right")
		"r_stick":
			return path.replace("/r_stick", "/right_track")
		"r_stick_up":
			return path.replace("/r_stick_up", "/right_track_up")
		"r_stick_down":
			return path.replace("/r_stick_down", "/right_track_down")
		"r_stick_left":
			return path.replace("/r_stick_left", "/right_track_left")
		"r_stick_right":
			return path.replace("/r_stick_right", "/right_track_right")
		_:
			return path
