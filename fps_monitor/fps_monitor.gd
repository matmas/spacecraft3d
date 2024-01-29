extends Label


func _ready() -> void:
	z_index = -1
	if OS.get_name() == "Android":
		label_settings.font_size = 30
		position.x = -50  # some phones have rounded corners


func _process(_delta: float) -> void:
	text = """\
	{fps} FPS
	{time_process}ms process
	{time_physics}ms physics
	""".format({
		"fps": Performance.get_monitor(Performance.TIME_FPS),
		"time_process": "%.0f" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000),
		"time_physics": "%.0f" % (Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000),
	})
