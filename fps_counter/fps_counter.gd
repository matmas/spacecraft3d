extends Label


func _ready() -> void:
	z_index = -1
	if OS.get_name() == "Android":
		position.x -= 25  # some phones have rounded corners


func _process(_delta: float) -> void:
	if GameOptions.get_handler("display", "fps_counter").current_value:
		text = """\
		{fps} FPS
		{time_process}ms process
		{time_physics}ms physics
		""".format({
			"fps": Performance.get_monitor(Performance.TIME_FPS),
			"time_process": "%.0f" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000),
			"time_physics": "%.0f" % (Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000),
		})
	else:
		text = ""
