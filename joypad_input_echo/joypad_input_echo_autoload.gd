extends Node
# https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#echo-events

const DELAY_SEC = 0.6
const RATE = 25  # repeats per second

var held_event: InputEventAction = null
var time_pressed_msec: int
var delay_timer := Timer.new()
var repeat_timer := Timer.new()

const REPEATABLE_ACTIONS = [&"ui_left", &"ui_right", &"ui_up", &"ui_down"]

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
			if event.is_released() and held_event and held_event.is_action(action, true):
				_cancel_echo()
			if event.is_pressed() and held_event == event:
				return  # Our own echo events
			if event.is_pressed():
				# Setting event to held_event won't work for joysticks
				# because the UI controls won't register them
				# since they produce events continuously compared to buttons
				held_event = InputEventAction.new()
				held_event.action = action
				held_event.pressed = true
				delay_timer.start()
				repeat_timer.stop()
			return

	# Joysticks moving close to 0 should not cancel echo
	if event.is_pressed():
		_cancel_echo()


func _cancel_echo() -> void:
	held_event = null
	delay_timer.stop()
	repeat_timer.stop()


func _on_delay_timer_timeout() -> void:
	if held_event:
		_echo_held_button()
		repeat_timer.start()


func _on_repeat_timer_timeout() -> void:
	if held_event:
		_echo_held_button()
	else:
		repeat_timer.stop()


func _echo_held_button() -> void:
	Input.parse_input_event(held_event)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			held_event = null
			delay_timer.stop()
			repeat_timer.stop()
