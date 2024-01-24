extends Node3D


@onready var camera := get_viewport().get_camera_3d()


func _ready() -> void:
	var timer := Timer.new()
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	timer.timeout.connect(_timer_process)
	add_child(timer)
	timer.start()


func _timer_process() -> void:
	print(camera.name + str(camera.global_transform.origin))
	print(global_transform.origin)
	#global_transform.origin -= camera.global_transform.origin
