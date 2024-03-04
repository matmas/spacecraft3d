extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Input.get_connected_joypads().size():
		text = "Detected controllers: %s\n" % Input.get_connected_joypads().size()

	for device in Input.get_connected_joypads():
		var joy_info := Input.get_joy_info(device)
		var vendor_id: int = joy_info["vendor_id"]
		var product_id: int = joy_info["product_id"]
		var raw_name: String = joy_info["raw_name"]
		text += "%04x-%04x-%s%s\n" % [vendor_id, product_id, raw_name, "*" if Input.is_joy_known(device) else ""]

#045e-0b12-Microsoft Xbox Series S|X Controller*
#03eb-ff01-Wooting One (Legacy)
