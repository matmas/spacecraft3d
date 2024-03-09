extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Input.get_connected_joypads().size():
		text = "Detected controllers: %s\n" % Input.get_connected_joypads().size()

	for device in Input.get_connected_joypads():
		var joy_info := Input.get_joy_info(device)
		if joy_info:
			if "vendor_id" in joy_info and "product_id" in joy_info and "raw_name" in joy_info:
				var vendor_id: int = joy_info["vendor_id"]
				var product_id: int = joy_info["product_id"]
				var raw_name: String = joy_info["raw_name"]
				text += "%04x-%04x-%s%s" % [vendor_id, product_id, raw_name, "*" if Input.is_joy_known(device) else ""]
			else:
				text += str(joy_info)
		text += " \"%s\"" % Input.get_joy_name(device)
		text += " %s\n" % Input.get_joy_guid(device)

# 045e-028e-Xbox Wireless Controller* 050000005e0400008e02000030110000 (Xbox series controller, Bluetooth, Linux) Share button works as F12
# 045e-0b12-Microsoft Xbox Series S|X Controller* 030000005e040000120b000009050000 (Xbox series controller, USB, Linux) Share button works as A
# "Xbox Controller" 47656e6572696320582d426f78207061 (Xbox series controller, USB, Android) LT/RT swapped, Select button doesn't work, LT/RT work for get_axis but are stuck when using Input.is_action_just_pressed()
# "Xbox One Controller" 58626f7820576972656c65737320436f (Xbox series controller, Bluetooth, Android) Same as with USB
# {"xinput_index": 0} "XInput Gamepad" __XINPUT_DEVICE__ (Xbox series controller, Bluetooth/USB, Windows 10)
# "Unknown" 556e6b6e6f776e (Xbox series controller, Bluetooth/USB, MacOS)
# 03eb-ff01-Wooting One (Legacy) 03000000eb03000001ff000093000000
