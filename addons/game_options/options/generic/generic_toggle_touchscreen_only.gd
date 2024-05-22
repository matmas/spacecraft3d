extends GenericBoolOption


func is_visible() -> bool:
	return DisplayServer.is_touchscreen_available()
