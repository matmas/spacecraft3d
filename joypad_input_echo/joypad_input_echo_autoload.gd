extends Node
# https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#echo-events

const REPEATABLE_ACTIONS = [&"ui_left", &"ui_right", &"ui_up", &"ui_down"]
const DELAY_SEC = 0.6
const RATE = 25  # repeats per second

var delay_timer := Timer.new()
var repeat_timer := Timer.new()
var repeating_event: InputEventAction = null

func _ready() -> void:
	delay_timer.wait_time = DELAY_SEC
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_on_delay_timer_timeout)
	add_child(delay_timer)
	repeat_timer.wait_time = 1.0 / RATE
	repeat_timer.timeout.connect(_on_repeat_timer_timeout)
	add_child(repeat_timer)


func _input(event: InputEvent) -> void:
	for action in REPEATABLE_ACTIONS:
		if event.is_action(action, true):
			if event.is_pressed():
				if event == repeating_event:
					return  # Ignore our own echo events here
				# Setting received event to repeating_event won't work for joysticks
				# because the UI controls won't register them
				# since they produce events continuously compared to buttons
				repeating_event = InputEventAction.new()
				repeating_event.action = action
				repeating_event.pressed = true
				delay_timer.start()
				repeat_timer.stop()
			else:
				if repeating_event and repeating_event.is_action(action, true):
					_cancel_echo()
			return

	# Joysticks moving close to 0 should not cancel echo
	if event.is_pressed():
		_cancel_echo()


func _cancel_echo() -> void:
	repeating_event = null
	delay_timer.stop()
	repeat_timer.stop()


func _on_delay_timer_timeout() -> void:
	if repeating_event:
		if Input.is_action_pressed(repeating_event.action):
			_echo_held_button()
			repeat_timer.start()


func _on_repeat_timer_timeout() -> void:
	if repeating_event:
		if Input.is_action_pressed(repeating_event.action):
			_echo_held_button()
		else:
			repeat_timer.stop()
	else:
		repeat_timer.stop()


func _echo_held_button() -> void:
	Input.parse_input_event(repeating_event)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			repeating_event = null
			delay_timer.stop()
			repeat_timer.stop()
